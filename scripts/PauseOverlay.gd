extends ColorRect

var in_modal = false

func _process(_delta):
	if not get_tree().paused or in_modal:
		return
	
	if Input.is_action_just_pressed("primary_action"):
		unpause()


func _on_ContinueBtn_pressed():
	unpause()

func unpause():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
