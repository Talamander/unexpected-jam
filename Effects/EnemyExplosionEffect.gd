extends "res://Effects/ExplosionEffect.gd"


func _ready():
	decayTimer.start()
	particle1.set_emitting(true)
	particle2.set_emitting(true)
	particle3.set_emitting(true)
	Global.emit_signal("add_screenshake", 1, 0.2)
