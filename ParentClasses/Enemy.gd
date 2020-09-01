extends KinematicBody2D

var explosion = preload("res://Effects/EnemyExplosionEffect.tscn")
var hit = preload("res://Effects/HitEffect.tscn")

var motion = Vector2.ZERO

var stun = false

onready var stats = $EnemyStats
onready var enemySprite = $Sprite
onready var stunTimer = $StunTimer

func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_died():
	queue_free()

func _on_StunTimer_timeout():
	pass

func hit_effect():
	Global.instance_scene_on_main(hit, enemySprite.global_position)

func death_effect():
	SoundFx.play("Explosion", rand_range(0.5, 1.5), 9)
	Global.instance_scene_on_main(explosion, enemySprite.global_position)
