extends Node2D

onready var particles = $Particles2D

func _ready():
	particles.emitting = true
