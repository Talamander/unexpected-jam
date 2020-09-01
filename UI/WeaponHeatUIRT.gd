extends Node2D

var PlayerStats = Global.PlayerStats

func _ready():
	PlayerStats.connect("player_died", self, "_on_died")

func _on_died():
	queue_free()
