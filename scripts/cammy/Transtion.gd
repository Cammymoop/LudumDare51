extends TextureRect

var active: = false
var whole_length: = 0.35

func _process(_delta):
	if not active:
		return
	
	var progress = 1 - ($Timer.time_left / whole_length)
	var mat = material as ShaderMaterial
	mat.set_shader_param("progress", progress * 1.1)
	
	if $Timer.time_left == 0:
		active = false

func do_transition() -> void:
	active = true
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	texture = tex
	
	$Timer.wait_time = whole_length
	$Timer.start()
