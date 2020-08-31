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

#Movement Variables
var baseSpeed = 400
var dashSpeed = 600
var speed = null
var acceleration = 4000
var bulletsInClip = 16
var timer = null
var reloadDelay = 2
var can_shoot = true
var motion = Vector2.ZERO
var stun = false

#Signals
signal player_died


#This function runs on the load
func _ready():
	
	speed = baseSpeed
	#Sets the global.gd (singleton) var player to self. So enemies can reference it
	Global.player = self
	
	PlayerStats.connect("player_died", self, "_on_died")
	#Sets up timer for weapon reload
	timer = Timer.new()
	#Makes timer only run itself once when called
	timer.set_one_shot(true)
	#Sets length of timer
	timer.set_wait_time(reloadDelay)
	timer.connect("timeout", self, "weapon_Reload")
	add_child(timer)

#This function runs when the player is destroyed
func _exit_tree():
	Global.player = null

#Runs every tick
func _physics_process(delta):
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
		#if clip is empty
		if bulletsInClip == 0:
			can_shoot = false
		#if clip isn't empty set can_shoot to true
		#if can_shoot is true run fire_bullet and subtract 1 bullet from clip
		if can_shoot == true:
			fire_bullet()
			#Tracks number of bullets in clip
			bulletsInClip -= 1
		#otherwise run the reload function instead
		elif can_shoot == false and timer.time_left == 0:
			timer.start()
	if Input.is_action_pressed("ui_space"):
		dash()

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

func weapon_Reload():
	can_shoot = true
	#Resets bulletsInClip back to 16 after timer
	bulletsInClip = 16
	
func fire_bullet():
	#Instances the playerBullet scene via the Global.gd singleton.
	var bullet = Global.instance_scene_on_main(playerBullet, playerSprite.global_position)
	
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
		stun = true
		Global.emit_signal("add_screenshake", 2, 0.15)

func _on_died():
	Global.instance_scene_on_main(explosion, playerSprite.global_position)
	emit_signal("player_died")
	queue_free()

func _on_StunTimer_timeout():
	self.modulate = Color("4c65b9")
	stun = false
