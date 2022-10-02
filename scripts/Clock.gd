extends Timer

var blue: = true

func _on_Timer_timeout():
	blue = not blue
	get_tree().call_group("clockable", "clock_tick", blue)

func _process(_delta):
	get_tree().call_group("more_clockable", "clock_update", 1 - time_left/wait_time)
