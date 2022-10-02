extends Resource
class_name PointsAndHealth

export(int) var points
export(int) var health
export(int) var max_health
export(float) var time
export(int) var total_score

var points_gained_in_tick = 0
var ticks_without_points = 0

const ticks_until_damage = 2
const points_to_heal = 10.0

func add_points(point_val: int) -> void:
	print("[points]: add points")
	points = points + point_val
	points_gained_in_tick = points_gained_in_tick + point_val
	ticks_without_points = 0
	
func tick():
	print("[points]: tick")
	if points_gained_in_tick > points_to_heal:
		print("[points]: add health")
		health = clamp(health + floor(points_gained_in_tick / points_to_heal), 0, max_health)
		
	if points_gained_in_tick <= 0:
		print("[points]: no point tick")
		ticks_without_points = ticks_without_points + 1
		
		if ticks_without_points > ticks_until_damage:
			health = clamp(health - 1, 0, max_health)
			print("[points]: no points damage, " + str(health) + " health")
		
	points_gained_in_tick = 0
		
		
func add_time(delta):
	time = time + delta
