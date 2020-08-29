extends Area2D
#Hitboxes deliver damage to other source


export(int) var damage = 1

# warning-ignore:unused_signal
func _on_Hitbox_area_entered(hurtbox):
	hurtbox.emit_signal("hit", damage)
