extends Resource
class_name PlayerStats


export(int)var max_health = 4
var health = max_health setget set_health
var MaxHeat = 16
var currentHeat = MaxHeat setget set_heat

signal player_health_changed(value)
signal player_died
signal player_heat_changed(value)


func set_health(value):
	if value < health:
		Global.emit_signal("add_screenshake", 0.15, 0.15)
	
	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", health)
	
	if health == 0:
		emit_signal("player_died")

func set_heat(value):
	currentHeat = clamp(value, 0, MaxHeat)
	emit_signal("player_heat_changed", currentHeat)
