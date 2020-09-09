extends CenterContainer

onready var killCounter = $VBoxContainer/VBoxContainer3/KillCount
onready var waveCounter = $VBoxContainer/VBoxContainer3/WaveCount




func _process(delta):
	killCounter.text = ("Enemies Killed: ") + str(Global.enemiesKilled)
	waveCounter.text = ("Waves Survived: ") + str(Global.currentWave - 1)


func _on_RestartButton_pressed():
	SignalManager.emit_signal("game_restarted")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	_on_reset()


func _on_ReturnToButton_pressed():
	get_tree().change_scene("res://Menus/MainMenu.tscn")
	_on_reset()

func _on_reset():
	Global.PlayerStats.health = Global.PlayerStats.max_health
	Global.PlayerStats.currentAmmo = Global.PlayerStats.MaxAmmo
	Global.currentEnemies = 0
	Global.currentWave = 1
	Global.currentModifier = "start"
	Global.enemiesThisWave = 0
	Global.enemyWaveLimit = 10
	Global.enemiesKilled = 0
