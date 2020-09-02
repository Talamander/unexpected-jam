extends KinematicBody2D

var explosion = preload("res://Effects/EnemyExplosionEffect.tscn")
var hit = preload("res://Effects/HitEffect.tscn")

var motion = Vector2.ZERO

var stun = false

onready var stats = $EnemyStats
onready var enemySprite = $Sprite
onready var stunTimer = $StunTimer


export var speed = 425
export var acceleration = 4000

signal enemy_died


func check_the_distance():
	var distance = self.position.distance_to(Global.player.position)
	return distance

func chase_player(delta, value):
	var direction = (Global.player.global_position - global_position).normalized()
	#if check_the_distance() > chaseLength:
	motion += direction * acceleration * delta
	motion = motion.clamped(speed)
	motion = move_and_slide(motion)
	
	rotation = direction.angle()


func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_died():
	Global.currentEnemies -= 1
	queue_free()

func _on_StunTimer_timeout():
	pass

func hit_effect():
	SoundFx.play("Hit", rand_range(.5, 1.2), -9)
	Global.instance_scene_on_main(hit, enemySprite.global_position)

func death_effect():
	SoundFx.play("Explosion", rand_range(0.6, 1.4), 5)
	Global.instance_scene_on_main(explosion, enemySprite.global_position)
