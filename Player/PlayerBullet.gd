extends "res://ParentClasses/Projectile.gd"

#Bullet speed
export var speed = 550

func _ready():
	SoundFx.play("Bullet", rand_range(0.6, 2.2), -7)
	Global.emit_signal("add_screenshake", .5, 0.15)
