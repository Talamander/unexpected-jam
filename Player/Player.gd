extends KinematicBody2D


var playerBullet = preload("res://Player/PlayerBullet.tscn")

onready var playerSprite = $Sprite
onready var fireRate = $FireRate


#Movement Variables
var speed = 400
var acceleration = 4000
var motion = Vector2.ZERO

#This function runs on the load
func _ready():
	#Sets the global.gd (singleton) var player to self. So enemies can reference it
	Global.player = self

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
		fire_bullet()

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

func fire_bullet():
	#Instances the playerBullet scene via the Global.gd singleton.
	var bullet = Global.instance_scene_on_main(playerBullet, playerSprite.global_position)
	bullet.velocity = Vector2.RIGHT.rotated(self.rotation) * bullet.speed
	#Adds a little kick, tweak the number to change intensity
	motion -= bullet.velocity * .75
	fireRate.start()
