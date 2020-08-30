extends Resource
class_name PlayerStats


export(int)var max_health = 4
var health = max_health setget set_health

signal player_health_changed(value)
signal player_died

func set_health(value):
	if value < health:
		Global.emit_signal("add_screenshake", 0.15, 0.15)
	
	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", health)
	
	if health == 0:
		emit_signal("player_died")
