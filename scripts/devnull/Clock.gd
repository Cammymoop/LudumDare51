extends Node

func _on_Timer_timeout():
	get_tree().call_group("clockable", "clock_tick")
	pass # Replace with function body.
