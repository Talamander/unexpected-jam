extends Node2D

onready var particles = $Particles2D
var playerColor = "57b4e2"
var enemyColor = "ff3b3b"
export(bool) var isPlayer = null

func _ready():
	particles.emitting = true
	if isPlayer:
		particles.modulate = Color(playerColor)
	else:
		particles.modulate = Color(enemyColor)
