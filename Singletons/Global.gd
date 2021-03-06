extends Node

var PlayerStats = preload("res://ParentClasses/PlayerStats.tres")
var healthItem = preload("res://Items/HealthItem.tscn")
var ammoItem = preload("res://Items/AmmoItem.tscn")

var player = null
var player_name = null
var total_score = 0 setget set_score

var MaxEnemies = 25
var currentEnemies = 0 setget set_enemies
var enemiesKilled = 0
var enemiesThisWave = 0
var enemyWaveLimit = 10
var currentWave = 1
var itemDropRates = null

var previousModifier = "start"
var currentModifier = "start"

var lighting_enabled = true
var hints_enabled = true

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

# warning-ignore:unused_argument
func set_score(value):
	var enemyScoreVal = 100
	var waveScoreVal = 500
	var enemyScore = enemyScoreVal * enemiesKilled
	var waveScore = waveScoreVal * (currentWave - 1)
	total_score = enemyScore + waveScore

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
		SoundFx.play("NewWave", 1, 1)

func itemDrop(position):
	itemDropRates = randi()%20+1
	match itemDropRates:
		1,2,3:
			instance_scene_on_main(healthItem, position)
			
		4,5,6,7:
			instance_scene_on_main(ammoItem, position)
