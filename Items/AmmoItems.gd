extends Node

onready var timer = get_node("InitialDecay")
onready var animator = $AnimationPlayer


func _ready():
	timer.start()
	animator.play("bounce")

func _AmmoPickUp(body):
	if body == Global.player:
		Global.PlayerStats.currentAmmo += 32
		Global.player.canShoot = true
		queue_free()

func _InitialAmmoDecay_timeout():
	queue_free()
