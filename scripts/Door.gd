extends Spatial

export(NodePath) var switch = null
onready var switch_node: Node = get_node(switch) if switch else null

var moving: = false
var going_out: = true

var move_timer: = 0.0
var move_duration: = 2.0

func _ready():
	if switch_node:
		switch_node.connect("off", self, "go")
		switch_node.connect("on", self, "go_back")

func _physics_process(delta):
	if not moving:
		return
	move_timer = min(move_duration, move_timer + delta)
	
	var destination = global_transform
	var from = $Destination.global_transform
	if going_out:
		destination = $Destination.global_transform
		from = global_transform
	
	$DoorBody.global_transform = from.interpolate_with(destination, move_timer/move_duration)
	
	if move_timer == move_duration:
		moving = false

func go() -> void:
	if moving:
		move_timer = move_duration - move_timer
	else:
		move_timer = 0
	going_out = true
	moving = true

func go_back() -> void:
	if moving:
		move_timer = move_duration - move_timer
	else:
		move_timer = 0
	going_out = false
	moving = true
