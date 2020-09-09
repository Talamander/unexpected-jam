extends CenterContainer

onready var killCounter = $VBoxContainer/VBoxContainer3/KillCount
onready var waveCounter = $VBoxContainer/VBoxContainer3/WaveCount


func _process(delta):
	killCounter.text = ("Enemies Killed: ") + str(Global.enemiesKilled)
	waveCounter.text = ("Waves Survived: ") + str(Global.currentWave - 1)
	if Input.is_action_just_released("pause"):
		pause()

func _on_RestartButton_pressed():
	pause()

func _on_ReturnToButton_pressed():
	pause()
	get_tree().change_scene("res://Menus/MainMenu.tscn")
	_on_reset()

func pause():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state

func _on_reset():
	Global.PlayerStats.health = Global.PlayerStats.max_health
	Global.PlayerStats.currentAmmo = Global.PlayerStats.MaxAmmo
	Global.currentEnemies = 0
	Global.currentWave = 1
	Global.currentModifier = "start"
	Global.enemiesThisWave = 0
	Global.enemyWaveLimit = 10
	Global.enemiesKilled = 0
