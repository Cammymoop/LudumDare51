extends Spatial

var saved = false

onready var enemy_container = get_node("%EnemyContainer")
onready var player_container = get_node("%Player")
onready var spawn_position = $SpawnPosition
onready var indicator = $Indicator
onready var sound_player: AudioStreamPlayer3D = $SaveSound

var save_state = {
	"player": {
		"position": null
	},
	"enemies": {}
}

# REPLACE THIS WITH IMPLEMENTATION
func _input(_event):
	if Input.is_action_just_pressed("restart") and saved:
		reset_savestate()
		

func _on_SaveTrigger_body_entered(_body):
	if saved:
		return
	saved = true
	indicator.visible = true
	sound_player.play()
	
	save_state["player"]["position"] = spawn_position.global_transform.origin
	
	for enemy in enemy_container.get_children():
		var enemy_node: Enemy = enemy
		save_state["enemies"][enemy_node.name] = {
			"position": enemy_node.global_transform.origin,
			"active": enemy_node.active
		}

func reset_savestate():
	var player_physics = player_container.get_node("PlayerBody")
	player_physics.global_transform.origin = save_state["player"]["position"]
	player_physics.linear_velocity = Vector3.ZERO
	
	for enemy_name in save_state["enemies"]:
		var enemy: Enemy = enemy_container.get_node(enemy_name)
		enemy.reset(
			save_state["enemies"][enemy_name]["position"],
			save_state["enemies"][enemy_name]["active"]
		)
