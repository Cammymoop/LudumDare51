extends Spatial

onready var ui = $LevelDoneUI
onready var score_grid = $LevelDoneUI/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer
onready var player_container = get_node("%Player")

func _on_Trigger_body_entered(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Load all the player score data
	var player = player_container.get_node("PlayerBody")
	var point_res = player.point_and_health
	score_grid.get_node("ScoreValue").text = "%d" % point_res.points
	score_grid.get_node("HealthValue").text = "%d" % [point_res.health * 100]
	score_grid.get_node("TimeRaw").text = "%02d:%02d" % [
		int(point_res.time) / 60,
		int(point_res.time) % 60
	]
	score_grid.get_node("TimeValue").text = "%d" % [int(point_res.time) % 20 * 10]
	
	var total_score = point_res.points + point_res.health * 100 + int(point_res.time) % 20 * 10
	score_grid.get_node("TotalValue").text = "%d" % total_score
	
	get_tree().paused = true
	ui.visible = true
