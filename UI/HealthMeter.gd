extends Control

var PlayerStats = Global.PlayerStats

onready var full = $Full


func _ready():
	PlayerStats.connect("player_health_changed", self, "_on_player_health_changed")
	

func _on_player_health_changed(amount):
	full.rect_size.x = amount * 5
