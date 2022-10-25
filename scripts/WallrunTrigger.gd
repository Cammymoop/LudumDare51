extends Area

func _on_Area_body_entered(body):
	if body.has_signal("wallrun_enter"):
		# The direction the wall is facing (note that thi isn't actually 
		# the opposite of the normal if the player is "behind" the wall)
		# this doesn't really matter in this case, and the actual normal can be used
		# without issue later on, the only important thing is that the vector
		# points in the same direction as the normal, the actual value or orientation
		# gets accounted for with the dot product step
		var wall_normal : Vector3 = global_transform.basis.y
		
		# A vector pointing to the right of the player
		var player_right : Vector3 = body.face.global_transform.basis.x
		
		# A float value of 1.0 if the player right is in the same direction
		# as the wall normal, and -1 if they are in opposite directions
		# (or perpendicular)
		var facing  : float = player_right.dot(wall_normal)
		facing = 1.0 if facing > 0 else -1.0
		
		# Snaps the right direction of the new basis to the closest orientation
		# of the wall normal vector(this deals with the possibility of the normal
		# being inverted as well), projecting it on the horizontal plane
		# in case the wall is inclined
		var x = facing*wall_normal
		x.y = 0.0
		x = x.normalized()
		# the Y of the new basis should always point UP, the basis simply
		# rotates around the Y axis
		var y = Vector3.UP
		# Godot uses right handed coordinates. So, to get an orthonormal basis,
		# x.cross(y) == z, y.cross(z) == x, z.cross(x) == y
		# this way, if you have any 2 vectors of an orthonormal basis, you can
		# get the third.
		# orthonormal means that all the vectors are perpendicular to each
		# other (ortho), and that they all have length 1.0 (normal)
		var z = x.cross(y)
		
		body.emit_signal("wallrun_enter", Basis(x, y, z))


func _on_Area_body_exited(body):
	if body.has_signal("wallrun_exit"):
		body.emit_signal("wallrun_exit")
