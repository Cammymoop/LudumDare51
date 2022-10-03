extends ColorRect

func _process(_delta):
	if not get_tree().paused:
		return
	
	if Input.is_action_just_pressed("primary_action"):
		visible = false
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
