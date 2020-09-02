extends Node2D

var basicEnemy = preload("res://Enemies/ShootingEnemy.tscn")
var instancetimer = null
var instancetimerlength = 3
var instanceEffect = ["Explosive Modifier", "Teleporting Enemies", "Dashing Enemies", "Shotgun Enemies",
"KillSwitch", "Damage Modifier"]

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

func _on_EnemySpawnTimer_timeout():
	var enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	

	while enemy_position.x < 640 and enemy_position.x > -80 or enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	
	Global.instance_scene_on_main(basicEnemy, enemy_position)
	
func instanceEffectSlicer():
	instanceEffect.shuffle()
	print(instanceEffect[0])
	return instanceEffect[0]
