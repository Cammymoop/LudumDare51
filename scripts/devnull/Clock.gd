extends Timer

func _on_Timer_timeout():
	get_tree().call_group("clockable", "clock_tick")
