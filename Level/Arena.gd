extends Node2D

var basicEnemy = preload("res://Enemies/BasicEnemy.tscn")
var shootingEnemy = preload("res://Enemies/ShootingEnemy.tscn")
var radialEnemy = preload("res://Enemies/360Enemy.tscn")
var teleportingEnemy = preload("res://Enemies/TeleportEnemy.tscn")

#Enemy Types for Wave 1
var enemyTypesWaveOne = [
	basicEnemy
]
#Evemy Types for Wave 2
var enemyTypesWaveTwo = [
	basicEnemy,
	shootingEnemy
]
#Evemy Types for Wave 3
var enemyTypesWaveThree = [
	basicEnemy,
	basicEnemy,
	basicEnemy,
	radialEnemy
]
#Evemy Types for Wave 4
var enemyTypesWaveFour = [
	basicEnemy,
	basicEnemy,
	basicEnemy,
	basicEnemy,
	teleportingEnemy
]

#Enemy Types for Wave3+
var enemyTypes = [
basicEnemy,
basicEnemy,
basicEnemy,
basicEnemy,
basicEnemy,
shootingEnemy, 
shootingEnemy, 
shootingEnemy, 
shootingEnemy, 
shootingEnemy, 
radialEnemy, 
radialEnemy, 
teleportingEnemy,
teleportingEnemy,
teleportingEnemy
]

var instancetimer = null
var instancetimerlength = 15
var distanceFromPlayer = 0
var instanceEffect = ["KillSwitch", "Damage Modifier", "Reverse Movement"]

#Stuff later
func _ready():
	Music.list_play()
	instancetimer = Timer.new()
	instancetimer.set_one_shot(false)
	instancetimer.set_wait_time(instancetimerlength)
	instancetimer.connect("timeout", self, "instanceEffectSlicer")
	add_child(instancetimer)
	instancetimer.start()

# warning-ignore:unused_argument
func _process(delta):
	
	if Input.is_action_just_pressed("restart"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		Global.PlayerStats.health = Global.PlayerStats.max_health
		Global.PlayerStats.currentAmmo = Global.PlayerStats.MaxAmmo

func _on_EnemySpawnTimer_timeout():
	if (Global.currentEnemies < Global.MaxEnemies) and Global.enemiesThisWave != Global.enemyWaveLimit:
		var enemy_position = Vector2(rand_range(-1060, 1160), rand_range(-340, 900))
		
		
		while enemy_position.x < 640 and enemy_position.x > -80 or enemy_position.y < 360 and enemy_position.y > -45:
			enemy_position = Vector2(rand_range(-1060, 1160), rand_range(-340, 900))
		if Global.player != null:
			distanceFromPlayer = enemy_position.distance_to(Global.player.position)
		if distanceFromPlayer > 400:
			if Global.currentWave == 1:
				enemyTypesWaveOne.shuffle()
				
				var enemyThatSpawns = enemyTypesWaveOne[0]
				
				Global.instance_scene_on_main(enemyThatSpawns, enemy_position)
				Global.currentEnemies += 1
				Global.enemiesThisWave += 1
			elif Global.currentWave == 2:
				enemyTypesWaveTwo.shuffle()
				
				var enemyThatSpawns = enemyTypesWaveTwo[0]
				
				Global.instance_scene_on_main(enemyThatSpawns, enemy_position)
				Global.currentEnemies += 1
				Global.enemiesThisWave += 1
			elif Global.currentWave == 3:
				enemyTypesWaveThree.shuffle()
				
				var enemyThatSpawns = enemyTypesWaveThree[0]
				
				Global.instance_scene_on_main(enemyThatSpawns, enemy_position)
				Global.currentEnemies += 1
				Global.enemiesThisWave += 1
			elif Global.currentWave == 4:
				enemyTypesWaveFour.shuffle()
				
				var enemyThatSpawns = enemyTypesWaveFour[0]
				
				Global.instance_scene_on_main(enemyThatSpawns, enemy_position)
				Global.currentEnemies += 1
				Global.enemiesThisWave += 1
			elif Global.currentWave >= 3:
				enemyTypes.shuffle()
				var enemyThatSpawns = enemyTypes[0]
				Global.instance_scene_on_main(enemyThatSpawns, enemy_position)
				Global.currentEnemies += 1
				Global.enemiesThisWave += 1
			print ("Current Enemies:", Global.currentEnemies)
			
			print ("Enemies Killed:", Global.enemiesKilled)
		else:
			print ("too close")

func instanceEffectSlicer():
	instanceEffect.shuffle()
	return instanceEffect[0]
