tool
extends StaticBody

export var is_red: = true setget set_red

var red_matt = preload("res://assets/textures/RedSquares.tres")
var red_matt_off = preload("res://assets/textures/RedSquaresOff.tres")
var blue_matt = preload("res://assets/textures/BlueScales.tres")
var blue_matt_off = preload("res://assets/textures/BlueScalesOff.tres")

var on: = true

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
		if is_blue:
			$MeshInstance.material_override = red_matt_off
			on = false
		else:
			$MeshInstance.material_override = red_matt
			on = true
	else:
		if is_blue:
			$MeshInstance.material_override = blue_matt
			on = true
		else:
			$MeshInstance.material_override = blue_matt_off
			on = false
			
	set_collision_layer_bit(0, on)
	set_collision_layer_bit(2, on)
	set_collision_mask_bit(0, on)
