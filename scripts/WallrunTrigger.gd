extends Area

func _on_Area_body_entered(body):
	if body.has_signal("wallrun_enter"):
		
		var player_forward = body.face.global_transform.basis.z
		var wall_x = global_transform.basis.x
		var res = player_forward.dot(wall_x)
		
		var s_res = sign(res) if not sign(res) == 0 else 1
			
		var z = wall_x * s_res
		var y = Vector3.UP
		var x = y.cross(z)
		
		body.emit_signal("wallrun_enter", Basis(x, y, z))


func _on_Area_body_exited(body):
	if body.has_signal("wallrun_exit"):
		body.emit_signal("wallrun_exit")
