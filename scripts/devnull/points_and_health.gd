extends Resource
class_name PointsAndHealth

export(int) var points
export(int) var health
export(int) var max_health
export(float) var time

var points_gained_in_tick = 0
var ticks_without_points = 0

func add(point_val: int) -> void:
	print("[points]: add points")
	points = points + point_val
	points_gained_in_tick = points_gained_in_tick + (point_val % 10)
	ticks_without_points = 0
	
func tick():
	print("[points]: tick")
	if points_gained_in_tick > 10:
		print("[points]: add health")
		health = clamp(health + floor(points_gained_in_tick / 10.0), 0, max_health)
		
	if points_gained_in_tick <= 0:
		print("[points]: no point tick")
		ticks_without_points = ticks_without_points + 1
		
	points_gained_in_tick = 0
		
	if ticks_without_points > 2:
		print("[points]: no points damage")
		health = clamp(health - 1, 0, max_health)
		
func add_time(delta):
	time = time + delta
