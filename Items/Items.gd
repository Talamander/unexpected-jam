extends Node


func _healthPickUp(body):
	PlayerStats.health += 1
	queue_free()

func _AmmoPickUp(body):
	PlayerStats.currentAmmo += 1
	queue_free()
