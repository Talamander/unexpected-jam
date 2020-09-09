extends Node2D

onready var particles = $Particles2D
onready var decayTimer = $Timer

func _ready():
	particles.emitting = true
	decayTimer.start()


func _on_Timer_timeout():
	queue_free()
