extends WorldEnvironment

var night_env = preload("res://assets/environment/NightEnvironment.tres")

func _ready():
	var day = rand_range(0, 1) >= 0.5
	
	if not day:
		$Sun.visible = false
		$Moon.visible = true
		environment = night_env
