extends Spatial

export(String) var next_lvl

onready var next_lvl_ui = $LevelDoneUI
onready var game_done_ui = $GameComplete
onready var score_grid = $LevelDoneUI/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer
onready var total_score_label = $GameComplete/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GameScore
onready var end_score_grid = $GameComplete/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer
onready var player_container = get_node("%Player")

var cache_total_score

const health_multiplyer = 25

func _ready():
	score_grid.get_node("HealthMulti").text = "x" + str(health_multiplyer)
	end_score_grid.get_node("HealthMulti").text = "x" + str(health_multiplyer)

func _on_Trigger_body_entered(body):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Load all the player score data
	var player = player_container.get_node("PlayerBody")
	var point_res = player.point_and_health
	score_grid.get_node("ScoreValue").text = "%d" % point_res.points
	score_grid.get_node("HealthValue").text = "%d" % [point_res.health * health_multiplyer]
	score_grid.get_node("TimeRaw").text = "%02d:%02d" % [
		int(point_res.time) / 60,
		int(point_res.time) % 60
	]
	var time_score = 360 - int(point_res.time)
	score_grid.get_node("TimeValue").text = "%d" % [time_score]
	
	var level_score = point_res.points + (point_res.health * health_multiplyer) + time_score
	score_grid.get_node("TotalValue").text = "%d" % level_score
	
	cache_total_score = player.point_and_health.total_score + level_score
	var end_lvl_score = score_grid.duplicate()
	end_score_grid.get_parent().add_child_below_node(end_score_grid, end_lvl_score)
	end_score_grid.queue_free()
	
	total_score_label.text = "Total game score: %d" % cache_total_score
	
	get_tree().paused = true
	if next_lvl:
		next_lvl_ui.visible = true
	else:
		game_done_ui.visible = true

func _on_next_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	call_deferred("on_idle_after_next")

func _on_QuiteBtn_pressed():
	get_tree().quit(0)

func _on_RestartGameBtn_pressed():
	get_tree().paused = false
	var lvl1_scene = load("res://scenes/levels/Lvl1.tscn")
	get_tree().change_scene_to(lvl1_scene)
	
func on_idle_after_next():
	var next_scene = load("res://scenes/levels/%s.tscn" % next_lvl)
	
	var cache = cache_total_score
	var current_scene_root = get_tree().current_scene
	current_scene_root.queue_free()
	
	var new_scene_root = next_scene.instance()
	get_tree().get_root().add_child(new_scene_root)
	get_tree().current_scene = new_scene_root
	new_scene_root.get_node("Player/PlayerBody").point_and_health.total_score = cache
