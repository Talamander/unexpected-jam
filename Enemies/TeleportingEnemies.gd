extends "res://ParentClasses/Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var teleportationDelay = null

# Called when the node enters the scene tree for the first time.

func _ready():
	teleportationDelay = Timer.new()
	teleportationDelay.set_one_shot(false)
	teleportationDelay.set_wait_time(0.5)
	teleportationDelay.connect("timeout", self, "teleportTimeout")
	add_child(teleportationDelay)
	teleportationDelay.start()
func teleportTimeout(delta):
	if Global.player != null:
		chase_player(delta, rotation)
func chase_player(delta, value):
	var direction = (Global.player.global_position - global_position).normalized()
	#if check_the_distance() > chaseLength:
	motion += direction * acceleration
	motion = move_and_slide(motion)
	
	rotation = direction.angle()

