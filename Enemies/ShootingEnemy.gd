extends "res://ParentClasses/Enemy.gd"

var enemyBullet = preload("res://Enemies/EnemyBullet.tscn")
var enemyColor = "ff3b3b"

onready var muzzle = $muzzle
onready var fireRate = $FireRate

export(int) var chaseLength = 230
export(int) var shootingDistance = 250


func _physics_process(delta):
	if Global.player != null:
		chase_player(delta, rotation)
		if check_the_distance() < shootingDistance:
			if fireRate.time_left == 0:
				fire_bullet()

func chase_player(delta, value):
	var direction = (Global.player.global_position - global_position).normalized()
	if check_the_distance() > chaseLength:
		motion += direction * acceleration * delta
		motion = motion.clamped(speed)
		motion = move_and_slide(motion)
	
	rotation = direction.angle()

func fire_bullet():
	#Instances the enemyBullet scene via the Global.gd singleton.
	var bullet = Global.instance_scene_on_main(enemyBullet, muzzle.global_position)
	
	#This code is a copy of the look_rotation function, couldn't figure out a way to cleanly call in the func.
	#This works for setting the bullets rotation and particle rotations though
	
	bullet.set_rotation(global_rotation)
	bullet.velocity = Vector2.RIGHT.rotated(self.rotation) * bullet.speed
	#Adds a little kick, tweak the number to change intensity
	#motion -= bullet.velocity * .1
	fireRate.start()


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
func _on_StunTimer_timeout():
	enemySprite.modulate = Color(enemyColor)
	#currently not doing anything with this stun variable, but it may come in handy
	stun = false


func _on_EnemyStats_enemy_died():
	Global.currentEnemies -= 1
	death_effect()
	queue_free()
