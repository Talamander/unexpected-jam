extends KinematicBody2D

var explosion = preload("res://Effects/EnemyExplosionEffect.tscn")
var hit = preload("res://Effects/HitEffect.tscn")
var teleportEffect = preload("res://Effects/TeleportEffect.tscn")

var motion = Vector2.ZERO
var previousMotion = Vector2.ZERO
var stun = false
var ifKillSwitch = null

onready var stats = $EnemyStats
onready var enemySprite = $Sprite
onready var stunTimer = $StunTimer


export onready var speed = 425 - randi()%100+1
export onready var acceleration = 4000


# warning-ignore:unused_signal
signal enemy_died


func check_the_distance():
	var distance = self.position.distance_to(Global.player.position)
	return distance

# warning-ignore:unused_argument
func chase_player(delta, value):
	var direction = (Global.player.global_position - global_position).normalized()
	#if check_the_distance() > chaseLength:
	motion += direction * acceleration * delta
	motion = motion.clamped(speed)
	previousMotion = motion
	motion = move_and_slide(motion)
	
	rotation = direction.angle()


func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_died():
	emit_signal("removed", self)
	Global.currentEnemies -= 1
	Global.enemiesKilled += 1
	Global.itemDrop(self.global_position)
	if killSwitch_Check() != true:
		pass
	else:
		ifKillSwitch = self.global_position
		teleport_effect()
		Global.player.global_position = ifKillSwitch
	death_effect()
	queue_free()

func killSwitch_Check():
	var checker = null
	if Global.currentModifier != "killSwitch":
		checker = false
		return checker
	else:
		checker = true
		return checker

func _on_StunTimer_timeout():
	pass

func hit_effect():
	SoundFx.play("Hit", rand_range(.5, 1.2), -9)
	Global.instance_scene_on_main(hit, enemySprite.global_position)

func death_effect():
	SoundFx.play("Explosion", rand_range(0.6, 1.4), 5)
	Global.instance_scene_on_main(explosion, enemySprite.global_position)
	
func teleport_effect():
	SoundFx.play("Teleport", rand_range(0.8, 1.1), 1)
	Global.instance_scene_on_main(teleportEffect, Global.player.global_position)
