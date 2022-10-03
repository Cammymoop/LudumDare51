extends CenterContainer
class_name HealthBubble

export(bool) var warn = false
export(bool) var danger = false
export(bool) var active = true

const active_color = Color(1, 0, 0, 1)
const inactive_color = Color(1, 1, 1, 1)
const danger_flash_time = 0.8

var cracked1 = preload("res://assets/textures/Cracked1Mat.tres")
var cracked2 = preload("res://assets/textures/Cracked2Mat.tres")

onready var border = $Border
onready var inner = $Inner

var danger_toggle_time = 0
var vanished: = false

func _ready():
	update()
	
func update():
	if active:
		if danger:
			$AnimationPlayer.play("flash")
			if inner.material != cracked2:
				inner.material = cracked2
		elif warn:
			$AnimationPlayer.play("solid")
			if inner.material != cracked1:
				inner.material = cracked1
		else:
			if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "flash":
				$AnimationPlayer.play("solid")
			if inner.material:
				inner.material = null
	
	if active and vanished:
		vanished = false
		$AnimationPlayer.play("vanish", -1, -2, true)
		$AnimationPlayer.queue("solid")
		
	if not active and not vanished:
		$Queued.visible = false
		vanished = true
		$AnimationPlayer.play("vanish")

func queued() -> void:
	$Queued.visible = true
