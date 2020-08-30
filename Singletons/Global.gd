extends Node

var PlayerStats = preload("res://ParentClasses/PlayerStats.tres")

# warning-ignore-all:unused_signal
signal add_screenshake(amount, duration)

var player = null


#Singleton for instancing scenes within a scene. ex: playerBullet
func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance
