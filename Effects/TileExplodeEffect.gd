extends Node2D

onready var tweenster = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	tweenster.interpolate_property(self, "modulate", Color(1, 1, 2, 1), Color(1, 1, 1, 0), .4, Tween.TRANS_SINE,Tween.EASE_OUT)
	tweenster.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	queue_free()
