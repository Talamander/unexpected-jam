extends Node

export(Array, AudioStream) var musiclist = []

var musiclist_index = 0

onready var MusicPlayer = $AudioStreamPlayer


func list_play():
	assert(musiclist.size() > 0)
	MusicPlayer.stream = musiclist[musiclist_index]
	MusicPlayer.play()
	musiclist_index += 1
	if musiclist_index == musiclist.size():
		musiclist_index = 0

func list_stop():
	MusicPlayer.stop()

func _on_AudioStreamPlayer_finished():
	list_play()
