extends Node

func _ready():
	read_settings()
	randomize()

func read_settings():
	var file = File.new()
	var err = file.open("user://settings.json", File.READ)
	if err == OK:
		var setting_str = file.get_as_text()
		var settings_parsed = JSON.parse(setting_str)
		if settings_parsed.error == OK:
			GlobalSettings.set_from_map(settings_parsed.result)
		else:
			print("unable to parse settings file ... help?!")
	file.close()

func write_settings():
	var file = File.new()
	var err = file.open("user://settings.json", File.WRITE)
	var settings = {
		"mouse_sensetivity": GlobalSettings.mouse_sensetivity,
		"controller_sensetivity_v": GlobalSettings.controller_sensetivity_v,
		"controller_sensetivity_h": GlobalSettings.controller_sensetivity_h,
		"fov": GlobalSettings.fov,
		"master_volume": GlobalSettings.master_volume,
	}
	var setting_str = JSON.print(settings)
	file.store_string(setting_str)
	file.close()
