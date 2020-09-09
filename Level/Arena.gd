extends Node2D

onready var modTimer = $ModifierTimer

var initModTimer = 30

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
var maxDistanceFromPlayer = 950
var modifierList = ["SlowMotion", "PlayerDamageIncrease", "ReverseMovement",
 "RecoilRange", "NoRecoil", "BasicRuleSet", "killSwitch", "noMiniMap"]

#Stuff later
func _ready():
	Music.list_play()
	modTimer.start()
	
	#for object in get_tree().get_nodes_in_group("minimap_object"):
		#object.connect("removed", $MiniMap, "_on_object_removed")

# warning-ignore:unused_argument
func _physics_process(delta):
	Global.previousModifier = Global.currentModifier
	if Input.is_action_just_pressed("restart"):
		reset_game()
	
	slow_mo_check()


func slow_mo_check():
	if Global.currentModifier == "SlowMotion":
		if modTimer.wait_time > (initModTimer * .3):
			modTimer.stop()
			modTimer.set_wait_time(initModTimer * .3)
			modTimer.start()
			print(modTimer.wait_time)
			Engine.time_scale = 0.3
	if Global.currentModifier != "SlowMotion":
		if modTimer.wait_time < initModTimer:
			modTimer.stop()
			modTimer.set_wait_time(initModTimer)
			modTimer.start()
			Engine.time_scale = 1

func _on_EnemySpawnTimer_timeout():
	if (Global.currentEnemies < Global.MaxEnemies) and Global.enemiesThisWave != Global.enemyWaveLimit:
		var enemy_position = Vector2(rand_range(-1060, 1160), rand_range(-340, 900))
		
		
		while enemy_position.x < 640 and enemy_position.x > -80 or enemy_position.y < 360 and enemy_position.y > -45:
			enemy_position = Vector2(rand_range(-1060, 1160), rand_range(-340, 900))
		
		if Global.player != null:
			distanceFromPlayer = enemy_position.distance_to(Global.player.position)
		
		if distanceFromPlayer > 400 and distanceFromPlayer < maxDistanceFromPlayer:
			
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
			pass
			#print ("Failed to spawn based on distance criteria")


func _on_ModifierTimer_timeout():
	modifierList.shuffle()
	while modifierList[0] == Global.previousModifier:
		modifierList.shuffle()
		print ("dupe")
	print ("set")
	Global.currentModifier = modifierList[0]
	print(Global.currentModifier)
	SoundFx.play("New Modifier", 1, 1)


func reset_game():
	get_tree().reload_current_scene()
	Global.PlayerStats.health = Global.PlayerStats.max_health
	Global.PlayerStats.currentAmmo = Global.PlayerStats.MaxAmmo
	Global.player.canShoot = true
	Global.currentEnemies = 0
	Global.currentWave = 1
	Global.currentModifier = "start"
	Global.enemiesThisWave = 0
	Global.enemyWaveLimit = 10
	Global.enemiesKilled = 0
	modTimer.stop()
	modTimer.start()
