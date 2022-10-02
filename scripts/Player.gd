extends Spatial

export(Vector3) var initial_camera_rotation = Vector3.ZERO

onready var face  = $CameraHolder

func _ready():
	face.global_rotation = initial_camera_rotation
