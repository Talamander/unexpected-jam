extends KinematicBody2D

var PlayerStats = Global.PlayerStats

#Preloading other scenes
var playerBullet = preload("res://Player/PlayerBullet.tscn")
var explosion = preload("res://Effects/ExplosionEffect.tscn")

#References to nodes under Player
onready var playerSprite = $Sprite
onready var fireRate = $FireRate
onready var stunTimer = $StunTimer
onready var dashTimer = $DashTimer
onready var light = $Light2D
onready var muzzle = $Muzzle

var playerColor = "57b4e2"

#Movement Variables
var baseSpeed = 400
var dashSpeed = 600
var speed = null
var acceleration = 4000
var weaponHeating = 0
var overHeatTimer = null
var coolDownTimer = null
var overheatDelay = 2
var weaponCoolDown = 0.6
var can_shoot = true
var motion = Vector2.ZERO
var stun = false

#Signals
signal player_died


#This function runs on the load
func _ready():
	self.modulate = Color(playerColor)
	speed = baseSpeed
	
	#Sets the global.gd (singleton) var player to self. So enemies can reference it
	Global.player = self
	
	PlayerStats.connect("player_died", self, "_on_died")
	
	
	#Sets up timer for weapon reload
	overHeatTimer = Timer.new()
	coolDownTimer = Timer.new()
	
	
	#Makes timer only run itself once when called
	overHeatTimer.set_one_shot(true)
	coolDownTimer.set_one_shot(false)
	
	
	#Sets length of timer
	overHeatTimer.set_wait_time(overheatDelay)
	coolDownTimer.set_wait_time(weaponCoolDown)
	
	
	#using connect dictates what each timer does when it reaches 0
	overHeatTimer.connect("timeout", self, "weapon_Overheat")
	coolDownTimer.connect("timeout", self, "weapon_CoolDown")
	add_child(overHeatTimer)
	add_child(coolDownTimer)

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
	motion = move_and_slide(motion)
	
	
	if Input.is_action_pressed("fire") and fireRate.time_left == 0:
		#cancels current cooldown timer if player begins shooting again
		if coolDownTimer.time_left != 0:
			coolDownTimer.stop()
		#if weaponHeating equals 32 it stops allowing the weapon to be fired
		if weaponHeating >= 32:
			can_shoot = false
		#if they havent reached the overheat point it fires a bullet and adds one to heating
		if can_shoot == true:
			print(weaponHeating)
			fire_bullet()
			#Tracks the bullets until overheat
			weaponHeating += 1
			PlayerStats.currentHeat -= 1
		#otherwise runs a forced weapon cooldown, causing 2 second delay before resetting clip
		elif can_shoot == false and overHeatTimer.time_left == 0:
			overHeatTimer.start()
	#for each second the player hasnt been shooting, when the timer ends it calls the weapon_CoolDown function
	else:
		if weaponHeating > 0 and coolDownTimer.time_left == 0:
			coolDownTimer.start()
	
	#Dash
	if Input.is_action_pressed("ui_space"):
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
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()

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






func weapon_Overheat():
	can_shoot = true
	#Resets weaponHeating back to 0 after timer
	weaponHeating = 12
	
func weapon_CoolDown():
	#Subtracts one from weaponHeating
	weaponHeating -= 2
	PlayerStats.currentHeat += 2

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
	motion -= bullet.velocity * .75
	fireRate.start()

func dash():
	speed = dashSpeed
	dashTimer.start()
	#Allows player to dash through enemies, may or may not want to keep
	#Will need a more robust system if we keep it, because as of now players can phase through walls
	get_node("CollisionShape2D").set_deferred("disabled", true)
	#Allows player not take damage while dashing
	get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)

func _on_DashTimer_timeout():
	speed = baseSpeed
	get_node("CollisionShape2D").set_deferred("disabled", false)
	get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", false)





func _on_Hurtbox_hit(damage):
	if stun == false:
		PlayerStats.health -= damage
		self.modulate = Color.white
		stunTimer.start()
		Global.emit_signal("add_screenshake", 2, 0.15)
		SoundFx.play("Hit", rand_range(.9, 1.5), 2)

func _on_died():
	Global.instance_scene_on_main(explosion, playerSprite.global_position)
	SoundFx.play("Explosion", rand_range(0.5, 1.5), 12)
	emit_signal("player_died")
	queue_free()

func _on_StunTimer_timeout():
	self.modulate = Color(playerColor)
	stun = false


func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Enemy"):
		stun = true
		var enemyRotation = body.rotation
		self.global_rotation_degrees = body.rotation_degrees
		#self.global_rotation_degrees += 45
		#motion = motion.rotated(enemyRotation) * 160
		print (global_rotation)
		var knockback = Vector2.RIGHT.rotated(self.rotation) * baseSpeed
		motion += knockback * 4
