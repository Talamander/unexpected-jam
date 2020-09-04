extends Node2D

onready var particles = $Particles2D
onready var decayTimer = $Timer

func _ready():
	decayTimer.start()
	particles.set_emitting(true)


func _on_Timer_timeout():
	queue_free()
