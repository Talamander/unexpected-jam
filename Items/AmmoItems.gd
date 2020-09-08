extends Node

onready var timer = get_node("InitialDecay")
onready var animator = $AnimationPlayer

var minimap_icon = "Pickup"

func _ready():
	SignalManager.emit_signal("item_spawn", self)
	timer.start()
	animator.play("bounce")

func _AmmoPickUp(body):
	if body == Global.player:
		Global.PlayerStats.currentAmmo += 32
		Global.player.canShoot = true
		SignalManager.emit_signal("item_despawn", self)
		queue_free()

func _InitialAmmoDecay_timeout():
	SignalManager.emit_signal("item_despawn", self)
	queue_free()
