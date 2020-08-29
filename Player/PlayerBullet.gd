extends "res://ParentClasses/Projectile.gd"

#Bullet speed
export var speed = 550

func _ready():
	SoundFx.play("Bullet", rand_range(0.6, 2.2), -7)
