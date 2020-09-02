extends Control

var PlayerStats = Global.PlayerStats

onready var meter = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.connect("player_ammo_changed", self, "_on_player_ammo_changed")

func _on_player_ammo_changed(value):
	meter.value = value
