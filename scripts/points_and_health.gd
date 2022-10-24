extends Resource
class_name PointsAndHealth

export(int) var points
export(int) var health: int
export(int) var max_health
export(float) var time
export(int) var total_score

var points_gained_in_tick = 0
var ticks_without_points = 0
var successful_hits_in_tick = 0

const ticks_until_damage = 2

func add_points(point_val: int) -> void:
	points = points + point_val
	points_gained_in_tick = points_gained_in_tick + point_val
	ticks_without_points = 0
	successful_hits_in_tick += 1
	
func tick():
	if successful_hits_in_tick >= 3:
		var heal = 1
		if successful_hits_in_tick >= 5:
			heal = 2
		health += heal
		
	if points_gained_in_tick <= 0:
		ticks_without_points = ticks_without_points + 1
		
		if ticks_without_points > ticks_until_damage:
			health = int(clamp(health - 1, 0, max_health))
		
	points_gained_in_tick = 0
	successful_hits_in_tick = 0
		

func get_queued_health() -> int:
	var heal: = 0
	if successful_hits_in_tick >= 3:
		heal = 1
		if successful_hits_in_tick >= 5:
			heal = 2
	return health + heal

func add_time(delta):
	time = time + delta
