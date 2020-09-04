extends Node2D

var basicEnemy = preload("res://Enemies/BasicEnemy.tscn")
var shootingEnemy = preload("res://Enemies/ShootingEnemy.tscn")
var radialEnemy = preload("res://Enemies/360Enemy.tscn")
var teleportingEnemy = preload("res://Enemies/TeleportEnemy.tscn")

var enemyTypes = [basicEnemy, shootingEnemy, radialEnemy, teleportingEnemy]

var instancetimer = null
var instancetimerlength = 15
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
		var enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		
		
		while enemy_position.x < 640 and enemy_position.x > -80 or enemy_position.y < 360 and enemy_position.y > -45:
			enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
			
		var distanceFromPlayer = enemy_position.distance_to(Global.player.position)
		
		if distanceFromPlayer > 400:
			enemyTypes.shuffle()
			var enemyThatSpawns = enemyTypes[0]
			Global.instance_scene_on_main(enemyThatSpawns, enemy_position)
			Global.currentEnemies += 1
			Global.enemiesThisWave += 1
			print ("Current Enemies:", Global.currentEnemies)
		else:
			print ("too close")

func instanceEffectSlicer():
	instanceEffect.shuffle()
	return instanceEffect[0]
