extends KinematicBody2D

onready var timer = get_node("InitialDecay")
onready var animator = $AnimationPlayer

var acceleration = 4000
var speed = 2000
var minimap_icon = "Pickup"

func _ready():
	SignalManager.emit_signal("item_spawn", self)
	timer.start()
	animator.play("bounce")

func _physics_process(delta):
	chase_player(delta*8)
	
func _healthPickUp(body):
	if body == Global.player:
		Global.PlayerStats.health += 5
		SignalManager.emit_signal("item_despawn", self)
		queue_free()

func _InitialHealthDecay_timeout():
	SignalManager.emit_signal("item_despawn", self)
	queue_free()

func check_the_distance():
	var distance = self.position.distance_to(Global.player.position)
	return distance

func chase_player(delta):
	if !Global.player:
		pass
	else:
		var direction = (Global.player.global_position - self.global_position).normalized()
		var motion = Vector2.ZERO
		if check_the_distance() < 75:
			motion += direction * acceleration * delta
			motion = motion.clamped(speed)
			motion = move_and_slide(motion)
	
	rotation += .11
