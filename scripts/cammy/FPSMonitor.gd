extends Label

func _ready():
	if not OS.has_feature("debug"):
		visible = false

func _process(_delta):
	text = "FPS " + str(Engine.get_frames_per_second())
