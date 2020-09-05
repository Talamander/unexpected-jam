extends Node

#var player = preload("")

func _healthPickUp(body):
	if body == Global.player:
		PlayerStats.health += 1
		queue_free()

func _AmmoPickUp(body):
	if body == Global.player:
		PlayerStats.currentAmmo += 1
		queue_free()
