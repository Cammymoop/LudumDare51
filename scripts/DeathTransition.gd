extends ColorRect

var active: = false
var whole_length: = 0.6

func _process(_delta):
	if not active:
		return
	
	var progress = 1 - ($Timer.time_left / whole_length)
	var mat = material as ShaderMaterial
	mat.set_shader_param("progress", progress * 1.1)
	
	if $Timer.time_left == 0:
		active = false
		visible = false

func do_transition() -> void:
	visible = true
	active = true
	
	$Timer.wait_time = whole_length
	$Timer.start()
