extends Node2D

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta

#Destroys the projectile after it has exited the viewport
func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()


func _on_Hitbox_body_entered(body):
	queue_free()


func _on_Hitbox_area_entered(area):
	queue_free()
