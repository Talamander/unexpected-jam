extends "res://ParentClasses/Projectile.gd"

onready var bulletSprite = $RegularSprite
onready var bulletCollision = $Hitbox/RegularShot
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

# warning-ignore:unused_argument
func _physics_process(delta):
	damage_increase_checker()
	if Global.currentModifier == "chargeShot" and Global.player.chargeShotDamage != 0:
		
		if Global.player.chargeShotDamage > 21 and Global.player.chargeShotDamage <= 32:
			get_node("SizeThreeShot").disabled = false
			get_node("SizeThreeSprite").visible = true
			get_node("SizeTwoShot").disabled = true
			get_node("SizeTwoSprite").visible = false
			get_node("RegularShot").disabled = true
			get_node("RegularSprite").visible = false
			
		elif Global.player.chargeShotDamage > 10 and Global.player.chargeShotDamage <= 21:
			get_node("SizeThreeShot").disabled = true
			get_node("SizeThreeSprite").visible = false
			get_node("SizeTwoShot").disabled = false
			get_node("SizeTwoSprite").visible = true
			get_node("RegularShot").disabled = true
			get_node("RegularSprite").visible = false
			
		elif Global.player.chargeShotDamage < 10 and Global.player.chargeShotDamage >= 1:
			get_node("SizeThreeShot").disabled = true
			get_node("SizeThreeSprite").visible = false
			get_node("SizeTwoShot").disabled = true
			get_node("SizeTwoSprite").visible = false
			get_node("RegularShot").disabled = false
			get_node("RegularSprite").visible = true
	else:
		get_node("SizeThreeShot").disabled = true
		get_node("SizeThreeSprite").visible = false
		get_node("SizeTwoShot").disabled = true
		get_node("SizeTwoSprite").visible = false
		get_node("RegularShot").disabled = false
		get_node("RegularSprite").visible = true

func damage_increase_checker():
	if Global.currentModifier != "PlayerDamageIncrease":
		$Hitbox.damage = 1
	elif Global.currentModifier == "chargeShot":
		$Hitbox.damage = Global.player.chargeShotDamage
	else:
		$Hitbox.damage = 2


func _on_Hitbox_body_entered(_body):
	if Global.currentModifier == "chargeShot" and Global.player.chargeShotDamage == 0:
		bulletSprite.visible = false
		get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
		trail.emitting = false
		trailTimer.start()
		if trailTimer.time_left == 0:
			queue_free()
	else:
		bulletSprite.visible = false
		get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
		trail.emitting = false
		trailTimer.start()
		if trailTimer.time_left == 0:
			queue_free()


func _on_Hitbox_area_entered(_area):
	if Global.currentModifier == "chargeShot" and Global.player.chargeShotDamage == 0:
		bulletSprite.visible = false
		get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
		trail.emitting = false
		trailTimer.start()
		if trailTimer.time_left == 0:
			queue_free()
	else:
		bulletSprite.visible = false
		get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)
		trail.emitting = false
		trailTimer.start()
		if trailTimer.time_left == 0:
			queue_free()


func _on_decayTimer_timeout():
	queue_free()
