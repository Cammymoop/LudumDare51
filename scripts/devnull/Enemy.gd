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

# One "Player" node needs to exist in level scene 
onready var player_node = get_node("%Player")

onready var blue_active_mat = load("res://assets/textures/TeamBlueActive.tres")
onready var blue_inactive_mat = load("res://assets/textures/TeamBlueInctive.tres")
onready var red_active_mat = load("res://assets/textures/TeamRedActive.tres")
onready var red_inactive_mat = load("res://assets/textures/TeamRedInactive.tres")

var active = true
var see_player = false

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

# Called by Scene/Clock every interval
func clock_tick():
	active = !active
	update_materials()
	update_player_target_state()
	
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

func update_player_target_state():
	if active and see_player:
		player_in_sight.visible = true
	else:
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
	player_finder.look_at(player_node.global_transform.origin, Vector3.UP)
	var finder_result = player_finder.get_collider()
	if finder_result and finder_result.name == "Player":
		see_player = true
	else:
		see_player = false
	
	update_player_target_state()
	update_movement(delta)
