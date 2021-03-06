extends Node

var sounds_path = "res://Music and Sounds/"

var sounds = {
	"Bullet" : load(sounds_path + "LaserTest.wav"),
	"Explosion" : load(sounds_path + "Explosion.wav"),
	"Teleport" : load(sounds_path + "teleport.wav"),
	"NewWave" : load(sounds_path + "NewWave.wav"),
	"New Modifier" : load(sounds_path + "rule_change.wav"),
	"Pickup" : load(sounds_path + "pickup.wav"),
	"Hit" : load(sounds_path + "hit.wav")
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
