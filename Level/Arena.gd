extends Node2D

var basicEnemy = preload("res://Enemies/BasicEnemy.tscn")

#Stuff later
func _ready():
	Music.list_play()


func _on_EnemySpawnTimer_timeout():
	var enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	

	while enemy_position.x < 640 and enemy_position.x > -80 or enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	
	Global.instance_scene_on_main(basicEnemy, enemy_position)
