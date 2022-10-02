extends CenterContainer
class_name HealthBubble

export(bool) var danger = false
export(bool) var active = true

const active_color = Color(1, 0, 0, 1)
const inactive_color = Color(1, 1, 1, 1)
const danger_flash_time = 0.8

onready var border = $Border
onready var inner = $Inner

var danger_toggle_time = 0

func _ready():
	update()
	
func _process(delta):
	if danger:
		danger_toggle_time = danger_toggle_time - delta
		if danger_toggle_time <= 0:
			border.visible = not border.visible
			danger_toggle_time = danger_flash_time
	else:
		if border.visible:
			border.visible = false
			
	if active and inner.color != active_color:
		 inner.color = active_color
		
	if not active and inner.color != inactive_color:
		inner.color = inactive_color
