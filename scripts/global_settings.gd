extends Node

var mouse_sensetivity = 10
var controller_sensetivity_h = 4
var controller_sensetivity_v = 2
var fov = 55.0
var master_volume = 100 setget set_master_volume

func set_from_map(map):
	fov = map["fov"]
	set_master_volume(map["master_volume"])
	mouse_sensetivity = map["mouse_sensetivity"]
	controller_sensetivity_h = map["controller_sensetivity_h"]
	controller_sensetivity_v = map["controller_sensetivity_v"]

func set_master_volume(vol):
	master_volume = vol
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(vol / 100))
