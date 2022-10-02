extends Spatial

var width: = 0.8
var shrink_factor: = 1.0

func _process(delta):
	if width <= 0:
		queue_free()
	
	width -= shrink_factor * delta
	$Line.mesh.size.y = min(0.1, width)
	
	if width < 0.2:
		$Sphere.scale = Vector3.ONE * min(1, width * 8)

func set_length(length) -> void:
	var qmesh = $Line.mesh as QuadMesh
	qmesh.size.x = length
	qmesh.center_offset.x = length/2
	# Only need to update 1 mesh they are the same resource
