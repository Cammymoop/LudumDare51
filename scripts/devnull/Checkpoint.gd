extends Spatial

var saved = false

onready var player_container = get_node("%Player")
onready var spawn_position = $SpawnPosition
onready var indicator = $Indicator
onready var sound_player: AudioStreamPlayer3D = $SaveSound
		

func _on_SaveTrigger_body_entered(_body):
	if saved:
		return
	saved = true
	indicator.visible = true
	sound_player.play()
	player_container.get_node("PlayerBody").last_spawn = spawn_position
