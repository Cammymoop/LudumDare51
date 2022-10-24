extends ColorRect

var in_modal = false

onready var settings_dialog = $SettingsDialog

func _on_ContinueBtn_pressed():
	unpause()

func unpause():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_SettingsBtn_pressed():
	settings_dialog.popup()

func _on_PauseOverlay_gui_input(event):
	if visible and  event is InputEventMouseButton:
		print("ping")
		var me = event as InputEventMouseButton
		if me.button_index == BUTTON_LEFT and me.pressed:
			unpause()
