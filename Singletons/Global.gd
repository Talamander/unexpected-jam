extends Node

var PlayerStats = preload("res://ParentClasses/PlayerStats.tres")
var healthItem = preload("res://Items/HealthItem.tscn")
var ammoItem = preload("res://Items/AmmoItem.tscn")

var player = null

var MaxEnemies = 25
var currentEnemies = 0 setget set_enemies
var enemiesKilled = 0
var enemiesThisWave = 0
var enemyWaveLimit = 10
var currentWave = 1
var itemDropRates = null

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
	
#Will handle wave system, currently in testing
#Its called inside EnemyStats
func waveRunner():
	if enemiesThisWave == enemyWaveLimit and currentEnemies == 0:
		currentWave += 1
		enemyWaveLimit += 10
		MaxEnemies += 0
		enemiesThisWave = 0
		print("Wave:",currentWave)

func itemDrop(position):
	itemDropRates = randi()%6+1
	match itemDropRates:
		1,2,3:
			Global.instance_scene_on_main(healthItem, position)
		4,5,6:
			Global.instance_scene_on_main(ammoItem, position)
