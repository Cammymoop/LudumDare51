extends KinematicBody
class_name Enemy

# This could be global
enum Team { Blue, Red }

const waypoint_distance_squared = 0.5
const movement_speed = 1

# Enemy configuration options
export(Team) var team = Team.Blue
export(bool) var shoot = false
export(bool) var start_inactive = false
export(NodePath) var path 					# If given use every child of the node as waypoints to move to in order

onready var head = $Head
onready var body = $Body
onready var player_finder = $PlayerFinder
onready var player_in_sight = $PlayerInSightMark
onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

# One "Player" node needs to exist in level scene 
onready var player_node = get_node("%Player")

onready var blue_active_mat = load("res://assets/textures/TeamBlueActive.tres")
onready var blue_inactive_mat = load("res://assets/textures/TeamBlueInctive.tres")
onready var red_active_mat = load("res://assets/textures/TeamRedActive.tres")
onready var red_inactive_mat = load("res://assets/textures/TeamRedInactive.tres")

var detect_sound = preload("res://assets/sfx/EnemyDetect.wav")

var active = true
var see_player = false
var time_since_last_seen = 0

# Internal waypoint state. Only uised when a "path" node path is set
var current_target: Spatial
var current_target_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	active = !start_inactive
	
	if path != "":
		var path_node = get_node(path)
		current_target = path_node.get_child(current_target_index)
	update_materials()
	
# Update materials 
func update_materials():
	if team == Team.Blue:
		if active:
			head.material_override = blue_active_mat
			body.material_override = blue_active_mat
		else:
			head.material_override = blue_inactive_mat
			body.material_override = blue_inactive_mat
	else:
		if active:
			head.material_override = red_active_mat
			body.material_override = red_active_mat
		else:
			head.material_override = red_inactive_mat
			body.material_override = red_inactive_mat

func update_player_target_state(delta):
	if active and see_player:
		time_since_last_seen = 0
		if !player_in_sight.visible:
			player_in_sight.visible = true
			if !audio_player.playing:
				audio_player.stream = detect_sound
				audio_player.play()
	else:
		time_since_last_seen = time_since_last_seen + delta
		if player_in_sight.visible and time_since_last_seen > 0.1:
			player_in_sight.visible = false
		
func update_movement(delta):
	if !current_target:
		return
	
	if global_transform.origin.distance_squared_to(current_target.global_transform.origin) < waypoint_distance_squared:
		current_target_index = current_target_index + 1
		var path_node = get_node(path)
		if path_node.get_child_count() <= current_target_index:
			current_target_index = 0
		current_target = path_node.get_child(current_target_index)
		
	var target_vector = current_target.global_transform.origin - global_transform.origin
	move_and_collide(target_vector.normalized() * delta * movement_speed)

func _physics_process(delta):
	update_movement(delta)
	
	# Look for player and update state if you are an aggregsive opponent
	if shoot:
		# Look at collision shape because that ist centered in collision. The body origin is at the very 
		# bottom tip of the shape and that leads to inconsistsnt detection
		var player_center = player_node.get_node("PlayerBody/CollisionShape").global_transform.origin
		
		# Lookahead so we dont look just behind the last player position
		var look_ahead_offset = player_node.get_node("PlayerBody").linear_velocity
		
		# Velocity is pretty beeeg so normalize if its above 1
		# Standing still is not noamlized so this is kind of like a clamp
		if look_ahead_offset.length() > 1:
			look_ahead_offset = look_ahead_offset.normalized()
		
		# Hacky additional lookahead reduction factor
		look_ahead_offset = look_ahead_offset * 0.3
		
		# Nor look at player position + offset
		player_finder.look_at(player_center + look_ahead_offset, Vector3.UP)
		
		# And see if we collide with player
		var finder_result = player_finder.get_collider()
		if finder_result:
			see_player = true
		else:
			see_player = false
		
		update_player_target_state(delta)

func _on_Timer_timeout():
	active = !active
	update_materials()
	update_player_target_state(0)
