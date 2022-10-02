extends Control

onready var shader: ShaderMaterial = $TextureRect.material

export(Color, RGBA) var red_color = Color.red
export(Color, RGBA) var blue_color = Color.blue

func _ready():
	$TextureRect.modulate = blue_color

func clock_tick(is_blue):
	if is_blue:
		$TextureRect.modulate = blue_color
	else:
		$TextureRect.modulate = red_color

func clock_update(progress):
	shader.set_shader_param("amount", 1 -progress)
