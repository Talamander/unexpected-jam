extends Control

onready var vidPlayer = $VideoPlayer
onready var mainMenu = $MainMenu
onready var optionsMenu = $OptionsMenu
onready var creditsMenu = $CreditsMenu
onready var helpMenu = $HelpMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	Music.list_play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	pass
	#vidPlayer.play()


func _on_StartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Level/Arena.tscn")


func _on_HelpButton_pressed():
	mainMenu.visible = false
	helpMenu.visible = true

func _on_CreditsButton_pressed():
	mainMenu.visible = false
	creditsMenu.visible = true


func _on_OptionsButton_pressed():
	optionsMenu.visible = true
	mainMenu.visible = false


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_BackButton_pressed():
	mainMenu.visible = true
	optionsMenu.visible = false
	creditsMenu.visible = false
	helpMenu.visible = false


# warning-ignore:unused_argument
func _on_CheckBox_toggled(button_pressed):
	pass # Replace with function body.


func _on_LightingToggle_toggled(button_pressed):
	if button_pressed == true:
		Global.lighting_enabled = true
	elif button_pressed == false:
		Global.lighting_enabled = false


func _on_MasterVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_MusicVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_SFXVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

