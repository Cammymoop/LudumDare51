extends RigidBody
class_name PlayerBodyCopy

var mouse_sensitivity = 0.002  # radians/pixel

var joystick_h_sensetivity = 4
var joystick_v_sensetivity = 2

onready var face = get_node("../CameraHolder")
onready var camera = face.get_node("Camera")
onready var health_container = get_node("../HUD/HealthContainer")

var max_ray_distance = 300

var grapple_intersect_point: Vector3 = Vector3.ZERO

const GRAPPLE_MASK: = 4
const GRAPPLEABLE_BIT: = 11

var move_force = 3400
var air_move_divider = 2.5

var jump_force = 16

var ground_drag = 1.8
var air_drag = 0.6

var point_and_health: PointsAndHealth = PointsAndHealth.new()
var last_spawn

var active = true

func _ready():
	point_and_health.health = 4
	last_spawn = get_parent()
	pass

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		if mouse_is_captured():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if active and Input.is_action_just_pressed("restart"):
		warp_to(last_spawn.global_transform.origin, last_spawn.global_rotation)
		return
	
	joystick_look(delta)
	
	if Input.is_action_just_pressed("primary_action"):
		if not mouse_is_captured():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			initiate_grapple()

func do_die() -> void:
	active = false
	
	var timer = get_tree().create_timer(0.6)
	# Do a fade out or something
	timer.connect("timeout", self, "reset_level")

func reset_level() -> void:
	get_tree().reload_current_scene()

func _physics_process(_delta):
	if global_transform.origin.y < -30:
		warp_to(last_spawn.global_transform.origin, last_spawn.global_rotation)

func _integrate_forces(state: PhysicsDirectBodyState):
	var delta = state.step
	
	var view_basis = face.transform.basis
	
	var on_ground = len($CheckGround.get_overlapping_bodies()) > 0
	
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
	

func can_grapple() -> bool:
	var pos = get_viewport().get_mouse_position()
	
	var space_state = get_world().direct_space_state
	  
	var from = camera.project_ray_origin(pos)
	var to = from + camera.project_ray_normal(pos) * max_ray_distance
	
	var intersection = space_state.intersect_ray(from, to, [], GRAPPLE_MASK)
	
	if intersection:
		if intersection.collider.get_collision_layer_bit(GRAPPLEABLE_BIT):
			grapple_intersect_point = intersection.position
			return true # collided with grappleable surface
		else:
			return false # collided with non-grappleable surface
	return false # hit nothing

func initiate_grapple() -> void:
	if not can_grapple():
		return
	if grapple_intersect_point == Vector3.ZERO:
		return
	
	warp_to(grapple_intersect_point, global_rotation)

func warp_to(new_pos: Vector3, new_rot: Vector3) -> void:
	linear_velocity = Vector3.ZERO
	global_rotation = new_rot
	global_translation = new_pos


func _on_PlayerBody_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if "bullet" in body.name.to_lower():
		warp_to(last_spawn.global_transform.origin, last_spawn.global_rotation)
