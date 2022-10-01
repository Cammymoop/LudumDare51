extends Timer

var blue: = true

func _on_Timer_timeout():
	blue = not blue
	get_tree().call_group("clockable", "clock_tick", blue)
