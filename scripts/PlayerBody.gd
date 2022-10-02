extends RigidBody

var mouse_sensitivity = 0.002  # radians/pixel

var joystick_h_sensetivity = 4
var joystick_v_sensetivity = 2

var shot_trail_scn = preload("res://scenes/cammy/ShotTrail.tscn")

onready var face = get_node("../CameraHolder")
onready var camera = face.get_node("Camera")
onready var shoot_from = camera.get_node("ShootFrom")
onready var health_container = get_node("../HUD/HealthContainer")
onready var ammo_container = get_node("../HUD/AmmoContainer")
onready var time_label = get_node("../HUD/StatsContainer/StatsListing/TimeBG/Time")

onready var HUD = get_node("../HUD")
onready var GameOverUI = get_node("../GameOver")

var point_and_health: PointsAndHealth = PointsAndHealth.new()

var max_ray_distance = 300

var hitscan_point: Vector3 = Vector3.ZERO
var hitscan_collider: PhysicsBody = null
var hitscan_is_grapple: = false
var hitscan_dist: = 300.0

const HITSCAN_MASK: = 4
const GRAPPLEABLE_BIT: = 11

var grapple_back_up_amount: = 1.1

var gravity = 29.4

var move_force = 3400
var air_move_divider = 2.5

var jump_force = 16

var ground_drag = 1.8
var air_drag = 0.6

var last_spawn: Spatial = null

var active = true
var can_shoot: = true
export(int) var max_ammo = 5
var ammo = 5
var recoil_amount: = 7.8
var recoil_velocity: = 0.0
var recoil_decay: = 14.0

var warped: = false

func _ready():
	# Setup start health and max health dynamic based on count of health
	# rects in UI
	point_and_health.health = health_container.get_child_count()
	point_and_health.max_health = health_container.get_child_count()
	
	# Initial player spwan is reset point
	last_spawn = get_parent()

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		if mouse_is_captured():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if abs(recoil_velocity) > 0.001:
		camera.rotate_x(recoil_velocity * mouse_sensitivity)
		recoil_velocity *= 1 - (delta *  recoil_decay)
	
	if not active:
		return
	
	if active and Input.is_action_just_pressed("restart"):
		do_die()
	if active and Input.is_action_just_pressed("hard_reset"):
		reset_level()
	
	joystick_look(delta)
	
	if Input.is_action_just_pressed("primary_action"):
		if not mouse_is_captured():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			fire()
			#initiate_grapple()
	
	if global_transform.origin.y < -30:
		respawn()
	
	update_health()
	
	point_and_health.add_time(delta)
	time_label.text = "%02d:%02d" % [int(point_and_health.time / 60), int(point_and_health.time) % 60]

func do_die() -> void:
	active = false
	
	var timer = get_tree().create_timer(0.6)
	# Do a fade out or something
	timer.connect("timeout", self, "respawn")

func reset_level() -> void:
	get_tree().reload_current_scene()

func respawn() -> void:
	active = true
	if not last_spawn:
		last_spawn = get_parent()
	warp_to(last_spawn.global_transform.origin, last_spawn.global_rotation)

func _physics_process(_delta):
	pass

func _integrate_forces(state: PhysicsDirectBodyState):
	var delta = state.step
	
	var view_basis = face.transform.basis
	
	var on_ground = len($CheckGround.get_overlapping_bodies()) > 0
	
	if not active:
		return
	
	linear_velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and on_ground:
		state.linear_velocity.y = clamp(state.linear_velocity.y, 0, jump_force)
		state.apply_central_impulse(Vector3.UP * jump_force)
	
	var movement = Input.get_axis("move_forward", "move_back")
	var strafe = Input.get_axis("move_left", "move_right")
	
	var move_vec = ((view_basis.z * movement) + (view_basis.x * strafe)).normalized()
	
	var total_move = move_vec * move_force * delta
	
	if on_ground:
		state.linear_velocity.x *= 1 - (delta *  ground_drag)
		state.linear_velocity.z *= 1 - (delta *  ground_drag)
	else:
		state.linear_velocity.x *= 1 - (delta *  air_drag)
		state.linear_velocity.z *= 1 - (delta *  air_drag)
		total_move /= air_move_divider
	state.add_central_force(total_move)
	

func mouse_is_captured() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if not mouse_is_captured():
		return
	
	if not active:
		return
	
	if event is InputEventMouseMotion:
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		face.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func joystick_look(delta) -> void:
	var h_look = Input.get_axis("look_right", "look_left")
	
	face.rotate_y(h_look * joystick_h_sensetivity * delta)
	
	var v_look = Input.get_axis("look_down", "look_up")
	
	camera.rotate_x(v_look * joystick_v_sensetivity * delta)
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)


func clock_tick(_is_blue):
	point_and_health.tick()
	update_health()
	
	ammo = max_ammo
	update_ammo()
	if $ShootCooldown.time_left <= 0:
		can_shoot = true
	
	if point_and_health.health <= 0:
		GameOverUI.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func update_health():
	for n in health_container.get_children():
		var health_bubble: HealthBubble = n as HealthBubble
		if not health_bubble:
			continue
			
		if health_bubble.get_index() < point_and_health.health:
			health_bubble.active = true
		else:
			health_bubble.active = false
			
		var is_last_health_bubble = health_bubble.get_index() == point_and_health.health - 1
		var is_in_danger_range = point_and_health.ticks_without_points >= point_and_health.ticks_until_damage
		if is_in_danger_range and is_last_health_bubble:
			health_bubble.danger = true
		else:
			health_bubble.danger = false
			
func update_ammo() -> void:
	var ammo_bubbles = ammo_container.get_children()
	ammo_bubbles.invert()
	var index = 0
	for n in ammo_bubbles:
		var ammo_bubble: AmmoBubble = n as AmmoBubble
		if not ammo_bubble:
			return
			
		if index < ammo:
			ammo_bubble.set_loaded(true)
		else:
			ammo_bubble.set_loaded(false)
		index += 1

func fire() -> void:
	if not can_shoot or ammo <= 0:
		return
	
	ammo = clamp(ammo - 1, 0, max_ammo)
	update_ammo()
	
	can_shoot = false
	$ShootCooldown.start()
	
	recoil_velocity += recoil_amount
	
	var something_hit = do_hitscan()
	
	var trail = shot_trail_scn.instance()
	trail.set_length(hitscan_dist)
	get_parent().add_child(trail)
	trail.global_translation = shoot_from.global_translation
	trail.look_at(hitscan_point, Vector3.UP)
	
	if not something_hit:
		return
	
	if hitscan_is_grapple:
		initiate_grapple()
	
		
	if hitscan_collider.has_signal("hit"):
		hitscan_collider.emit_signal("hit")
	
	if hitscan_collider.get("scorable"):
		point_and_health.add_points(hitscan_collider.points)

func do_hitscan() -> bool:
	hitscan_is_grapple = false
	var pos = get_viewport().get_mouse_position()
	
	var space_state = get_world().direct_space_state
	  
	var from = camera.project_ray_origin(pos)
	var to = from + camera.project_ray_normal(pos) * max_ray_distance
	
	var intersection = space_state.intersect_ray(from, to, [], HITSCAN_MASK)
	
	hitscan_dist = max_ray_distance
	
	if intersection:
		hitscan_point = intersection.position
		hitscan_dist = (intersection.position - shoot_from.global_translation).length()
		hitscan_collider = intersection.collider
		if intersection.collider.get_collision_layer_bit(GRAPPLEABLE_BIT):
			hitscan_is_grapple = true
			var local_point = hitscan_point - global_translation
			local_point -= local_point.normalized() * grapple_back_up_amount
			hitscan_point = local_point + global_translation
		return true
	
	hitscan_point = to # record point for shot trail
	return false # hit nothing

func initiate_grapple() -> void:
	if hitscan_point == Vector3.ZERO:
		return
	
	HUD.get_node("Transtion").do_transition()
	
	warped = true
	active = false
	$WarpTimer.start()
	
	warp_to(hitscan_point, global_rotation)

func warp_to(new_pos: Vector3, new_rotation: Vector3) -> void:
	linear_velocity = Vector3.ZERO
	global_translation = new_pos
	global_rotation = new_rotation


func _on_PlayerBody_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if "bullet" in body.name.to_lower():
		warp_to(last_spawn.global_transform.origin, last_spawn.global_rotation)


func _on_ShootCooldown_timeout():
	if ammo > 0:
		can_shoot = true

func _on_WarpTimer_timeout():
	if warped:
		warped = false
		active = true


func _on_RetryBtn_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	reset_level()

func _on_QuitBtn_pressed():
	get_tree().quit(0)
