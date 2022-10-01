extends Spatial

onready var ui = $LevelDoneUI

func _on_Trigger_body_entered(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	ui.visible = true
