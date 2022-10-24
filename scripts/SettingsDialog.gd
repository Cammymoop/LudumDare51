extends WindowDialog	

onready var mouse_sens_slider: HSlider = find_node("MouseSensSlider")
onready var controller_v_sens_slider: HSlider = find_node("ControllerVSensSlider")
onready var controller_h_sens_slider: HSlider = find_node("ControllerHSensSlider")
onready var fov_slider: HSlider = find_node("FOVSlider")
onready var volume_slider: HSlider = find_node("VolumeSlider")

onready var player_body = get_node("%PlayerBody")

func _on_SettingsDialog_about_to_show():
	mouse_sens_slider.value = GlobalSettings.mouse_sensetivity
	controller_v_sens_slider.value = GlobalSettings.controller_sensetivity_v
	controller_h_sens_slider.value = GlobalSettings.controller_sensetivity_h
	fov_slider.value = GlobalSettings.fov
	volume_slider.value = GlobalSettings.master_volume

func _on_SaveBtn_pressed():
	GlobalSettings.mouse_sensetivity = mouse_sens_slider.value
	GlobalSettings.controller_sensetivity_h = controller_h_sens_slider.value
	GlobalSettings.controller_sensetivity_v = controller_v_sens_slider.value
	GlobalSettings.master_volume = volume_slider.value
	GlobalSettings.fov = fov_slider.value
	
	Util.write_settings()
	
	player_body.update_settings()

func _on_CancelBtn_pressed():
	visible = false

func _on_SaveCloseBtn_pressed():
	_on_SaveBtn_pressed()
	visible = false

func _on_ResetBtn_pressed():
	GlobalSettings.mouse_sensetivity = 10
	GlobalSettings.controller_sensetivity_h = 4
	GlobalSettings.controller_sensetivity_v = 2
	GlobalSettings.master_volume = 100
	GlobalSettings.fov = 55.0

	Util.write_settings()
	
	player_body.update_settings()

	_on_SettingsDialog_about_to_show()
	
