extends Spatial

export(String) var next_lvl

onready var next_lvl_ui = $LevelDoneUI
onready var game_done_ui = $GameComplete
onready var score_grid = $LevelDoneUI/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer
onready var player_container = get_node("%Player")

var next_scene 

func _ready():
	if next_lvl:
		next_scene = load("res://scenes/levels/%s.tscn" % next_lvl)

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
	if next_scene:
		next_lvl_ui.visible = true
	else:
		game_done_ui.visible = true

func _on_next_pressed():
	get_tree().paused = false
	get_tree().change_scene_to(next_scene)

func _on_QuiteBtn_pressed():
	get_tree().quit(0)

func _on_RestartGameBtn_pressed():
	var lvl1_scene = load("res://scenes/levels/Lvl1.tscn")
	get_tree().change_scene_to(lvl1_scene)
