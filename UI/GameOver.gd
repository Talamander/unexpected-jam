extends CenterContainer




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RestartButton_pressed():
	SignalManager.emit_signal("game_restarted")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	Global.PlayerStats.health = Global.PlayerStats.max_health
	Global.PlayerStats.currentAmmo = Global.PlayerStats.MaxAmmo
	Global.currentEnemies = 0
	Global.currentWave = 1
	Global.currentModifier = "start"
	Global.enemiesThisWave = 0
	Global.enemyWaveLimit = 10
	Global.enemiesKilled = 0


func _on_ReturnToButton_pressed():
	pass # Replace with function body.
