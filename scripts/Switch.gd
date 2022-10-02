extends Spatial

signal off
signal on
signal toggle


export var on: = true

var animating: = false

func _process(delta):
	if not animating:
		return
	
	var off_pos = $OffPosition.global_translation
	var on_pos = $OnPosition.global_translation
	
	var to = off_pos
	if on:
		to = on_pos
	
	$MovingPart.global_translation = lerp($MovingPart.global_translation, to, delta * 3)
	if abs((to - $MovingPart.global_translation).length()) < 0.01:
		animating = false

func _on_ShootableBit_hit():
	if on:
		emit_signal("off")
	else:
		emit_signal("on")
	
	emit_signal("toggle")
	print("switched " + str(on))
	
	on = not on
	animating = true
