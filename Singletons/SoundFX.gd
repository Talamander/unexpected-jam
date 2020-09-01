extends Node

var sounds_path = "res://Music and Sounds/"

var sounds = {
	"Bullet" : load(sounds_path + "LaserTest.wav"),
	"Laser" : load(sounds_path + "LaserTest.wav")
}

onready var sound_players = get_children()

func play(sound_string, pitch_scale = 1, volume_db = 0):
	for soundPlayer in sound_players:
		if not soundPlayer.playing:
			soundPlayer.pitch_scale = pitch_scale
			soundPlayer.volume_db = volume_db
			soundPlayer.stream = sounds[sound_string]
			soundPlayer.play()
			return
	print ("too many sounds playing at once")
