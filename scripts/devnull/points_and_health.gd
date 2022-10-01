extends Resource
class_name PointsAndHealth

export(int) var points
export(int) var health
export(int) var max_health

var points_gained_in_tick = 0
var ticks_without_points = 0

func add(point_val: int) -> void:
	points = points + point_val
	points_gained_in_tick = points_gained_in_tick + 1
	ticks_without_points = 0
	
func tick(delta: float):
	if points_gained_in_tick > 3:
		health = clamp(health + 1, 0, max_health)
		
	if ticks_without_points > 2:
		health = clamp(health - 1, 0, max_health)
