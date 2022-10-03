extends Spatial

export var speed: = 5

func _process(delta):
	translate(Vector3.FORWARD * speed * delta)


func _on_Lifetime_timeout():
	queue_free()


func _on_Area_body_entered(body: PhysicsBody):
	if body.has_signal("hit"):
		body.emit_signal("hit")
	
	queue_free()
