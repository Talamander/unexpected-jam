extends "res://ParentClasses/Projectile.gd"

onready var bulletSprite = $Sprite
onready var bulletCollision = $Hitbox/CollisionShape2D
onready var trailTimer = $ParticleTrailTimer
onready var trail = $ParticleTrail



#Bullet speed
export var speed = 600

func _ready():
	SoundFx.play("Bullet", rand_range(0.5, 0.9), -2)
	Global.emit_signal("add_screenshake", .5, 0.15)
	trail.emitting = true


func _on_Hitbox_body_entered(_body):
	bulletSprite.visible = false
	get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
	trail.emitting = false
	trailTimer.start()
	if trailTimer.time_left == 0:
		queue_free()


func _on_Hitbox_area_entered(_area):
	bulletSprite.visible = false
	get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
	trail.emitting = false
	trailTimer.start()
	if trailTimer.time_left == 0:
		queue_free()
