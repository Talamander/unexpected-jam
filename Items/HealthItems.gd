extends Node

onready var timer = get_node("InitialDecay")

func _ready():
	timer.start()
	
func _healthPickUp(body):
	if body == Global.player:
		Global.PlayerStats.health += 1
		queue_free()

func _InitialHealthDecay_timeout():
	queue_free()
