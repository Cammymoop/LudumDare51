extends Spatial

export var enabled = true

func _ready():
	update()

func update():
	$StaticBody.set_collision_layer_bit(11, enabled)
	
	$MeshInstance.mesh.material.emission_enabled = enabled

func _on_Timer_timeout():
	enabled = not enabled
	update()
