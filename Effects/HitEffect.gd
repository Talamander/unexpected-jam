extends Node2D

onready var decayTimer = $Timer

func _ready():
	decayTimer.start()



func _on_Timer_timeout():
	queue_free()
