extends Spatial

var saved = false
var org_distance_squared
var final_position: Vector2 

export(Curve) var movement_curve: Curve

onready var player_container = get_node("%Player")
onready var spawn_position = $SpawnPosition
onready var indicator = $Indicator
onready var sound_player: AudioStreamPlayer3D = $SaveSound
onready var ui_label = $HUD/HUDHint

func _ready():
	var text_width = ui_label.get_node("FloatingLabel").rect_size.x
	ui_label.rect_global_position = get_viewport().get_mouse_position() - Vector2(text_width / 2, 0)
	final_position = get_viewport().get_mouse_position() - Vector2(text_width / 2, 200)
	org_distance_squared = ui_label.rect_global_position.distance_squared_to(final_position)

func _on_SaveTrigger_body_entered(_body):
	if saved:
		return
	saved = true
	indicator.visible = true
	sound_player.play()
	player_container.get_node("PlayerBody").last_spawn = spawn_position

	ui_label.visible = true
	
func _process(delta):
	if not ui_label.visible:
		return
	
	var dist = ui_label.rect_global_position.distance_squared_to(final_position)
	if dist < 10:
		ui_label.visible = false
		return
		
	var curve_x = dist / org_distance_squared
	var curve_y = movement_curve.interpolate_baked(curve_x)
		
	ui_label.rect_global_position = ui_label.rect_global_position.move_toward(final_position, delta * 200 * curve_y)
