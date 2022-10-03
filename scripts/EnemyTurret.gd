extends Spatial

export var is_red: = true

var alive: = true
var awake: = false

onready var open_anim = get_node("TurretWithShield/ShieldAnimator")
onready var head = get_node("TurretWithShield/Aim")

var target_body: PhysicsBody = null
var target_offset: Vector3 = Vector3.ZERO

var rotation_speed = 0.8

func _process(delta):
	if awake:
		if not $AgroZone.overlaps_body(target_body):
			go_to_sleep()
			target_body = null
			return
		
		var target_point = target_body.global_translation + target_offset
		var current_quat = Quat(head.global_transform.basis)
		var target_quat = Quat(head.global_transform.looking_at(target_point, Vector3.UP).basis)
		
		var angle_to = current_quat.angle_to(target_quat)
		if angle_to > 0:
			var amount = min(1, (rotation_speed * delta) / angle_to)
			var new_quat = current_quat.slerp(target_quat, amount)
			head.global_transform.basis = Basis(new_quat.normalized())
		

func _on_AgroZone_body_entered(body: PhysicsBody):
	target_body = body
	if body.has_node("AimAtMeHere"):
		target_offset = body.get_node("AimAtMeHere").translation
	else:
		target_offset = Vector3.ZERO
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
