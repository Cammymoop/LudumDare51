extends CenterContainer
class_name AmmoBubble

var active = true

onready var slot = $Loaded

func set_loaded(ac: bool) -> void:
	if not ac:
		slot.visible = false
	else:
		slot.visible = true
