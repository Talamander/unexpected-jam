extends Control

onready var vidPlayer = $VideoPlayer


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


func _on_CreditsButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Credits.tscn")


func _on_OptionsButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menus/Options.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
