extends StaticBody

# warning-ignore:unused_signal
signal hit

export var is_red: = true

var on: = true
var scorable: = true

var red_matt = preload("res://assets/textures/RedSquares.tres")
var red_matt_off = preload("res://assets/textures/RedSquaresOff.tres")
var blue_matt = preload("res://assets/textures/BlueScales.tres")
var blue_matt_off = preload("res://assets/textures/BlueScalesOff.tres")

export(int) var points = 5

func _ready():
	clock_tick(true)

func clock_tick(is_blue: bool) -> void:
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
	scorable = on

func hit() -> void:
	if on:
		queue_free()
