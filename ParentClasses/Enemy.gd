extends KinematicBody2D

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
