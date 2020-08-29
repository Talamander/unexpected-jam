extends "res://ParentClasses/Enemy.gd"

export var speed = 400
export var acceleration = 4000

func _physics_process(delta):
	if Global.player != null:
		chase_player(delta)

func chase_player(delta):
	var direction = (Global.player.global_position - global_position).normalized()
	motion += direction * acceleration * delta
	motion = motion.clamped(speed)
	motion = move_and_slide(motion)
