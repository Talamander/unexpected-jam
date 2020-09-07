extends Node

onready var timer = get_node("InitialDecay")
onready var animator = $AnimationPlayer

func _ready():
	timer.start()
	animator.play("bounce")
	
func _healthPickUp(body):
	if body == Global.player:
		Global.PlayerStats.health += 2
		queue_free()

func _InitialHealthDecay_timeout():
	queue_free()
