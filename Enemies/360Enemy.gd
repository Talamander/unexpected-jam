extends "res://ParentClasses/Enemy.gd"


var enemyBullet = preload("res://Enemies/EnemyBullet.tscn")
var enemyColor = "ff3b3b"

export(int) var chaseLength = 230
export(int) var shootingDistance = 250
export(float) var spread = 40

onready var muzzle = $muzzle
onready var muzzle2 = $muzzle2
onready var muzzle3 = $muzzle3
onready var muzzle4 = $muzzle4
onready var fireRate = $FireRate

func _physics_process(delta):
	#$Sprite.rotation = 90
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
	
	rotation += .06

func fire_bullet():
	#Instances the enemyBullet scene via the Global.gd singleton.
	var bullet1 = Global.instance_scene_on_main(enemyBullet, muzzle.global_position)
	
	#This code is a copy of the look_rotation function, couldn't figure out a way to cleanly call in the func.
	#This works for setting the bullets rotation and particle rotations though
	bullet1.speed = 300
	
	bullet1.set_rotation(muzzle.global_rotation)
	bullet1.velocity = Vector2.RIGHT.rotated(self.rotation) * bullet1.speed
	#bullet1.velocity = Vector2.RIGHT.rotated(deg2rad(rand_range(-spread/2, spread/2))) * bullet1.speed
	
	var bullet2 = Global.instance_scene_on_main(enemyBullet, muzzle2.global_position)
	
	bullet2.set_rotation(muzzle2.global_rotation)
	bullet2.velocity = -Vector2.RIGHT.rotated(self.rotation) * bullet1.speed
	
	var bullet3 = Global.instance_scene_on_main(enemyBullet, muzzle3.global_position)
	
	bullet3.set_rotation(muzzle3.global_rotation)
	bullet3.velocity = -Vector2.UP.rotated(self.rotation) * bullet1.speed
	
	var bullet4 = Global.instance_scene_on_main(enemyBullet, muzzle4.global_position)
	
	bullet4.set_rotation(muzzle4.global_rotation)
	bullet4.velocity = Vector2.UP.rotated(self.rotation) * bullet1.speed
	
	
	fireRate.start()

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

	
#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_StunTimer_timeout():
	enemySprite.modulate = Color(enemyColor)
	#currently not doing anything with this stun variable, but it may come in handy
	stun = false


func _on_FireRate_timeout():
	pass # Replace with function body.
