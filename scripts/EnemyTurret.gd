extends Spatial

export var is_red: = true

var alive: = true
var awake: = false

onready var open_anim = get_node("TurretWithShield/ShieldAnimator")

var target_body: PhysicsBody = null

func _process(delta):
	if awake:
		if not $AgroZone.overlaps_body(target_body):
			go_to_sleep()
			target_body = null

func _on_AgroZone_body_entered(body):
	target_body = body
	wake_up()


func wake_up():
	var start_at: float = 0.0
	if open_anim.is_playing():
		start_at = open_anim.current_animation_position
	
	open_anim.play("Lower")
	open_anim.seek(start_at, true)

func go_to_sleep():
	awake = false
	
	print("sleeping")
	var start_at: float = open_anim.get_animation("Lower").length
	if open_anim.is_playing():
		start_at = open_anim.current_animation_position
		print(start_at)
	
	open_anim.play_backwards("Lower")
	open_anim.seek(start_at, true)


func _on_ShieldAnimator_animation_finished(_anim_name):
	if open_anim.current_animation_position == 0:
		pass
	else:
		awake = true
