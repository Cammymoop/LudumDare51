tool
extends Spatial

# warning-ignore:unused_signal
signal hit

export var is_red: = true setget set_red

var on: = true

var red_matt = preload("res://assets/textures/RedGrapple.tres")
var blue_matt = preload("res://assets/textures/BlueGrapple.tres")

func _ready():
	if is_red:
		$MeshInstance.material_override = red_matt
	else:
		$MeshInstance.material_override = blue_matt
	clock_tick(true)

func set_red(value):
	is_red = value
	if Engine.editor_hint:
		clock_tick(true)

func clock_tick(is_blue: bool) -> void:
	if Engine.editor_hint:
		if is_red:
			$MeshInstance.material_override = red_matt
		else:
			$MeshInstance.material_override = blue_matt
		return
	if is_red:
		on = not is_blue
	else:
		on = is_blue
	
	$MeshInstance.material_override.emission_enabled = on
	$StaticBody.set_collision_layer_bit(11, on)
