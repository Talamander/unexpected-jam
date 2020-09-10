extends "res://ParentClasses/Enemy.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemyBullet = preload("res://Enemies/EnemyBullet.tscn")
var enemyColor = "ff3b3b"

onready var muzzle = $Muzzle
onready var fireRate = $FireRate

export(int) var shootingDistance = 250

var teleportationDelay = null

func _ready():
	teleportationDelay = Timer.new()
	teleportationDelay.set_one_shot(true)
	teleportationDelay.set_wait_time(3)
	#teleportationDelay.connect("timeout", self, "teleportTimeout")
	add_child(teleportationDelay)
	teleportationDelay.start()
	enemySprite.modulate = Color(enemyColor)
	
# Called when the node enters the scene tree for the first time.
# warning-ignore:unused_argument
func _physics_process(delta):
	if Global.player != null:
		if teleportationDelay.time_left == 0:
			teleport_to_player()
			teleportationDelay.start()
		#if check_the_distance() < shootingDistance:
		if fireRate.time_left == 0:
			fire_bullet()
		rotate_enemy()

func teleport_to_player():
	var a = randf() * 2 * PI
	var r = 170 * sqrt(randf())
	var x = r * cos(a)
	var y = r * sin(a)
	global_position = Global.player.global_position + Vector2(x,y)
	teleport_effect()
	#death_effect()

func rotate_enemy():
	var direction = (Global.player.global_position - global_position).normalized()
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
	motion -= motion * 45
	#currently not doing anything with this stun variable, but it may come in handy
	stun = true
	hit_effect()


#This function exists in Enemy parent class, but I decided to also put it here so enemies can be unique
func _on_StunTimer_timeout():
	enemySprite.modulate = Color(enemyColor)
	#currently not doing anything with this stun variable, but it may come in handy
	stun = false




func teleport_effect():
	SoundFx.play("Teleport", rand_range(0.8, 1.1), 1)
	Global.instance_scene_on_main(teleportEffect, enemySprite.global_position)
