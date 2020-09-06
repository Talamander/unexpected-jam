extends "res://ParentClasses/Projectile.gd"

onready var bulletSprite = $Sprite
onready var bulletCollision = $Hitbox/CollisionShape2D
onready var trailTimer = $ParticleTrailTimer
onready var trail = $ParticleTrail

onready var decayTimer = $decayTimer


#Bullet speed
export var speed = 600

func _ready():
	tilemap = get_parent().get_node("TileMap")
	SoundFx.play("Bullet", rand_range(0.5, 0.9), -11)
	Global.emit_signal("add_screenshake", .5, 0.15)
	trail.emitting = true

func _physics_process(delta):
	damage_increase_checker()

func damage_increase_checker():
	if Global.currentModifier != "PlayerDamageIncrease":
		$Hitbox.damage = 1
	else:
		$Hitbox.damage = 2


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


func _on_decayTimer_timeout():
	queue_free()
