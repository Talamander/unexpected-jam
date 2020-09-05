extends Node

#var player = preload("")

func _healthPickUp(body):
	if body == Global.player:
		Global.PlayerStats.health += 1
		queue_free()

func _AmmoPickUp(body):
	if body == Global.player:
		Global.PlayerStats.currentAmmo += 32
		Global.player.canShoot = true
		queue_free()
