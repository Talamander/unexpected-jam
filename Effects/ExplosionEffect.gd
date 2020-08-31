extends Node2D

onready var particle1 = $Particles2D
onready var particle2 = $Particles2D/Particles2D
onready var particle3 = $Particles2D/Particles2D2

onready var decayTimer = $Timer

func _ready():
	decayTimer.start()
	particle1.set_emitting(true)
	particle2.set_emitting(true)
	particle3.set_emitting(true)



func _on_Timer_timeout():
	queue_free()
