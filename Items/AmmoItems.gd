extends Node

onready var timer = get_node("InitialDecay")

func _ready():
	timer.start()

func _AmmoPickUp(body):
	if body == Global.player:
		Global.PlayerStats.currentAmmo += 32
		Global.player.canShoot = true
		queue_free()

func _InitialAmmoDecay_timeout():
	queue_free()
