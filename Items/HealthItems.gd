extends Node

onready var timer = get_node("InitialDecay")
onready var animator = $AnimationPlayer

var minimap_icon = "Pickup"

func _ready():
	SignalManager.emit_signal("item_spawn", self)
	timer.start()
	animator.play("bounce")
	
func _healthPickUp(body):
	if body == Global.player:
		Global.PlayerStats.health += 2
		SignalManager.emit_signal("item_despawn", self)
		queue_free()

func _InitialHealthDecay_timeout():
	SignalManager.emit_signal("item_despawn", self)
	queue_free()
