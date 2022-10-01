extends StaticBody

signal hit

export(int) var points = 5

func hit() -> void:
	queue_free()
