extends KinematicBody
class_name Enemy

# This could be global
enum Team { Blue, Red }

# Enemy configuration options
export(Team) var team = Team.Blue
export(bool) var shoot = false
export(bool) var start_inactive = false

onready var head = $Head
onready var body = $Body

onready var blue_active_mat = load("res://assets/textures/TeamBlueActive.tres")
onready var blue_inactive_mat = load("res://assets/textures/TeamBlueInctive.tres")
onready var red_active_mat = load("res://assets/textures/TeamRedActive.tres")
onready var red_inactive_mat = load("res://assets/textures/TeamRedInactive.tres")

var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	active = !start_inactive
	update_materials()

# Called by Scene/Clock every interval
func clock_tick():
	active = !active
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
