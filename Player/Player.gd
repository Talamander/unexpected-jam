extends KinematicBody2D

var PlayerStats = Global.PlayerStats

#Preloading other scenes
var playerBullet = preload("res://Player/PlayerBullet.tscn")
var explosion = preload("res://Effects/ExplosionEffect.tscn")
var dash_trail_effect = preload("res://Effects/DashTrailEffect.tscn")

#References to nodes under Player
onready var playerSprite = $Sprite
onready var fireRate = $Timers/FireRate
onready var stunTimer = $Timers/StunTimer
onready var dashTimer = $Timers/DashTimer
onready var dashRechargeTimer = $Timers/DashRechargeTimer
onready var light = $Light2D
onready var muzzle = $Muzzle

onready var ammoRegenTimer = $Timers/AmmoRegenTimer
onready var ammoRegenZeroedTimer = $Timers/AmmoRegenZeroedTimer

enum Layer {WORLD = 1, ENEMIES = 4}

var playerColor = "57b4e2"

#Movement Variables
var baseSpeed = 400
var dashSpeed = 600
var speed = null
var acceleration = 4000
var can_shoot = true
var can_dash = true
var is_dashing = false
var motion = Vector2.ZERO
var previousMotion = Vector2.ZERO
var stun = false
var isRecoilRangeInPlace = false
var currentRecoilRange = 0.0

var canShoot = true


#Signals
signal player_died


#This function runs on the load
func _ready():
	self.modulate = Color(playerColor)
	speed = baseSpeed
	
	#Sets the global.gd (singleton) var player to self. So enemies can reference it
	Global.player = self
	
	PlayerStats.connect("player_died", self, "_on_died")

#This function runs when the player is destroyed
func _exit_tree():
	Global.player = null

#Runs every tick
func _physics_process(delta):
	
	if stun == false:
		look_rotation()
	var input_vector = get_input_vector()
	
	#Vector2.ZERO is true when no move key is being pressed
	if input_vector == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		calc_movement(input_vector * acceleration * delta)
		
	#Godot's built in move_and_slide function handles the actual moving, just passing in the motion var
	previousMotion = motion
	motion = move_and_slide(motion)
	
	#Squash&Stretch - Kinda works - Looks cool with recoil
	if motion.y != 0:
		playerSprite.scale.y = range_lerp(abs(previousMotion.y), 0 , abs(baseSpeed), .5, .4)
		playerSprite.scale.x = range_lerp(abs(previousMotion.y), 0, abs(baseSpeed), .5, .6)
	if motion.x != 0:
		playerSprite.scale.y = range_lerp(abs(previousMotion.x), 0 , abs(baseSpeed), .5, .4)
		playerSprite.scale.x = range_lerp(abs(previousMotion.x), 0, abs(baseSpeed), .5, .6)
	
	
	if Input.is_action_pressed("fire") and fireRate.time_left == 0 and PlayerStats.currentAmmo > 0 and canShoot == true:
		fire_bullet()
		regen_ammo()
	
	#Dash
	if Input.is_action_pressed("ui_space") and can_dash == true:
		dash()
	
	#Disable light and shadows hotkey
	if Input.is_action_just_pressed("toggle_lights"):
		if light.visible == true:
			light.visible = false
		elif light.visible == false:
			light.visible = true


func get_input_vector():
	#input vector is direction of key input (WASD)
	var input_vector = Vector2.ZERO
	if reverse_movement_check() == false:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	else:
		input_vector.x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
		input_vector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	return input_vector.normalized()


func reverse_movement_check():
	var checker = null
	if Global.currentModifier != "ReverseMovement":
		checker = false
		return checker
	else:
		checker = true
		return checker
		
func recoilrange():
	var checker = null
	if Global.currentModifier != "RecoilRange":
		checker = false
		return checker
	elif Global.currentModifier != "RecoilRange" and isRecoilRangeInPlace==true:
		isRecoilRangeInPlace = false
		checker = true
		return checker
	else:
		checker = true
		return checker
		
func noRecoil():
	var checker = null
	if Global.currentModifier != "NoRecoil":
		checker = false
		return checker
	else:
		checker = true
		return checker

func apply_friction(amount):
	#Get the player movement moving smoothly
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

# warning-ignore:shadowed_variable
func calc_movement(acceleration):
	#Uses the acceleration to ramp up to the speed, so it's not instantaneous
	motion += acceleration
	motion = motion.clamped(speed)

func look_rotation():
	#Gets the mouse location and sets the player rotation to match
	var look_vector = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vector.y, look_vector.x)


func fire_bullet():
	#Instances the playerBullet scene via the Global.gd singleton.
	var bullet = Global.instance_scene_on_main(playerBullet, muzzle.global_position)
	
	#This code is a copy of the look_rotation function, couldn't figure out a way to cleanly call in the func.
	#This works for setting the bullets rotation and particle rotations though
	var look_vector = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vector.y, look_vector.x)
	bullet.set_rotation(global_rotation)
	bullet.velocity = Vector2.RIGHT.rotated(self.rotation) * bullet.speed
	#Adds a little kick, tweak the number to change intensity
	if recoilrange() == true:
		if isRecoilRangeInPlace == false:
			currentRecoilRange = float(rand_range(1, 1.5))
			isRecoilRangeInPlace = true
		else:
			pass
		motion -= bullet.velocity * currentRecoilRange
	if noRecoil() == true:
		motion -= bullet.velocity * 0
	else:
		motion -= bullet.velocity * .75
	fireRate.start()
	
	PlayerStats.currentAmmo -= 1


func regen_ammo():
	if PlayerStats.currentAmmo > 1:
		ammoRegenTimer.start()
	if PlayerStats.currentAmmo == 0:
		ammoRegenTimer.stop()
		ammoRegenZeroedTimer.start()
		canShoot = false

func _on_AmmoRegenTimer_timeout():
	if PlayerStats.currentAmmo < PlayerStats.MaxAmmo:
		PlayerStats.currentAmmo += 1
		#print (PlayerStats.currentAmmo)

func _on_AmmoRegenZeroedTimer_timeout():
	if PlayerStats.currentAmmo == 0:
		PlayerStats.currentAmmo += 32
		canShoot = true


func dash():
	speed = dashSpeed
	dashTimer.start()
	#Allows player to dash through enemies and walls
	self.set_collision_mask_bit(Layer.WORLD, false)
	self.set_collision_mask_bit(Layer.ENEMIES, false)
	#Allows player not take damage while dashing
	get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)
	is_dashing = true
	can_dash = false

func _on_DashTimer_timeout():
	speed = baseSpeed
	self.set_collision_mask_bit(Layer.WORLD, true)
	self.set_collision_mask_bit(Layer.ENEMIES, true)
	get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", false)
	can_dash = false
	dashRechargeTimer.start()
	is_dashing = false

func _on_DashRechargeTimer_timeout():
	can_dash = true

func _on_DashTrailTimer_timeout():
	if is_dashing == true:
		var dashtrail = Global.instance_scene_on_main(dash_trail_effect, playerSprite.global_position)
		#get_parent().add_child(dashtrail)
		#dashtrail.position = position
		#dashtrail.texture.texture = playerSprite
		dashtrail.rotation = rotation



func _on_Hurtbox_hit(damage):
	if stun == false:
		PlayerStats.health -= damage
		self.modulate = Color.white
		stunTimer.start()
		Global.emit_signal("add_screenshake", 2, 0.15)
		SoundFx.play("Hit", rand_range(.5, 1.2), -2)

func _on_died():
	Global.instance_scene_on_main(explosion, playerSprite.global_position)
	SoundFx.play("Explosion", rand_range(0.6, 1.4), 5)
	emit_signal("player_died")
	queue_free()

func _on_StunTimer_timeout():
	self.modulate = Color(playerColor)
	stun = false


func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("EnemyBullet"):
		stun = true
# warning-ignore:unused_variable
		var enemyRotation = body.rotation
		self.global_rotation_degrees = body.rotation_degrees
		#self.global_rotation_degrees += 45
		#motion = motion.rotated(enemyRotation) * 160
		#print (global_rotation)
		var knockback = Vector2.RIGHT.rotated(self.rotation) * baseSpeed
		motion += knockback * 4
		stunTimer.start()




