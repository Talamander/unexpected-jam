extends "res://ParentClasses/Enemy.gd"


var enemyColor = "ff3b3b"


func _physics_process(delta):
	if Global.player != null:
		chase_player(delta, rotation)





#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_Hurtbox_hit(damage):
	stats.health -= damage
	enemySprite.modulate = Color.white
	stunTimer.start()
	#Adds knockback on hit
	motion -= motion * 4
	#currently not doing anything with this stun variable, but it may come in handy
	stun = true
	hit_effect()
	
#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_EnemyStats_enemy_died():
	death_effect()
	queue_free()
	
#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_StunTimer_timeout():
	enemySprite.modulate = Color(enemyColor)
	#currently not doing anything with this stun variable, but it may come in handy
	stun = false


func _on_FireRate_timeout():
	pass # Replace with function body.
