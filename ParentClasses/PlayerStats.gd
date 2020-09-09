extends Resource
class_name PlayerStats


export(int)var max_health = 1
var health = max_health setget set_health
var MaxAmmo = 32
var currentAmmo = MaxAmmo setget set_ammo

signal player_health_changed(value)
signal player_died
signal player_ammo_changed(value)


func set_health(value):
	if value < health:
		Global.emit_signal("add_screenshake", 0.15, 0.15)
	
	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", health)
	
	if health == 0:
		emit_signal("player_died")

func set_ammo(value):
	currentAmmo = clamp(value, 0, MaxAmmo)
	emit_signal("player_ammo_changed", currentAmmo)
