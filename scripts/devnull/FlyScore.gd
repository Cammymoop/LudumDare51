extends Control

export(Curve) var movement_curve: Curve

onready var label = $Label

var final_position: Vector2
var org_distance_squared

const offset = Vector2(30, 0)

func _ready():
	final_position = get_target_location()
	org_distance_squared = rect_global_position.distance_squared_to(final_position)
	
func _process(delta):
	var dist = rect_global_position.distance_squared_to(final_position)
	if dist < 10:
		queue_free()
		return
		
	var curve_x = dist / org_distance_squared
	var curve_y = movement_curve.interpolate_baked(curve_x)
		
	rect_global_position = rect_global_position.move_toward(final_position, delta * 500 * curve_y)

func get_target_location():
	var last_pos: Vector2
	for n in get_node("../HealthContainer").get_children():
		var health_bubble: HealthBubble = n as HealthBubble
		if not health_bubble:
			continue
		
		if health_bubble.warn or health_bubble.danger:
			return health_bubble.rect_global_position + offset
			
			
		last_pos = health_bubble.rect_global_position
		
	return last_pos + offset
	
func set_score(score: float) -> void:
	label.text = "%d" % int(score)
