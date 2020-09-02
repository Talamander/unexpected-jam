extends Node

var PlayerStats = preload("res://ParentClasses/PlayerStats.tres")

var player = null

var MaxEnemies = 4
var currentEnemies = 0 setget set_enemies

# warning-ignore-all:unused_signal
signal add_screenshake(amount, duration)
signal enemy_count_changed(value)
signal enemy_died


#Singleton for instancing scenes within a scene. ex: playerBullet
func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance

func set_enemies(value):
	currentEnemies = clamp(value, 0, MaxEnemies)
	emit_signal("enemy_count_changed", currentEnemies)
