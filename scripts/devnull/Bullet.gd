extends KinematicBody

const bullet_speed = 20

var lifetime = 3

func _physics_process(delta):
	var vec = global_transform.translated(Vector3.FORWARD).origin - global_transform.origin
	var coll = move_and_collide(vec * delta * bullet_speed)
	if coll:
		queue_free()
		return
		
	lifetime = lifetime - delta
	if lifetime <= 0:
		queue_free()
