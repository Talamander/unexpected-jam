extends "res://ParentClasses/Enemy.gd"

export var speed = 425
export var acceleration = 4000




func _physics_process(delta):
	if Global.player != null:
		chase_player(delta)

func chase_player(delta):
	var direction = (Global.player.global_position - global_position).normalized()
	motion += direction * acceleration * delta
	motion = motion.clamped(speed)
	motion = move_and_slide(motion)




#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_Hurtbox_hit(damage):
	stats.health -= damage
	enemySprite.modulate = Color.white
	stunTimer.start()
	#Adds knockback on hit
	motion -= motion * 4
	#currently not doing anything with this stun variable, but it may come in handy
	stun = true
	
#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_EnemyStats_enemy_died():
	queue_free()
	
#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_StunTimer_timeout():
	enemySprite.modulate = Color("fa4d4d")
	#currently not doing anything with this stun variable, but it may come in handy
	stun = false
