extends Node2D

onready var tweenster = $AlphaTween

func _ready():
	tweenster.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	tweenster.start()

func _on_AlphaTween_tween_completed(object, key):
	queue_free()
