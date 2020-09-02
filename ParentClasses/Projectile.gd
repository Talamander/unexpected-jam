extends KinematicBody2D

var velocity = Vector2.ZERO

var tilehit = preload("res://Effects/TileExplodeEffect.tscn")
var hit = preload("res://Effects/HitEffect.tscn")

var collision: KinematicCollision2D
var collided = false

var tilemap
var cell
var tile_id



func _physics_process(delta):
	position += velocity * delta
	if (!collided):
		collision = move_and_collide(velocity * delta)
	if (collision != null and !collided):
		#velocity = -(0.2 * velocity)
		collided = true
		if (collision.collider.name == "TileMap"):
			cell = tilemap.world_to_map(collision.position - collision.normal)
			tile_id = tilemap.get_cellv(cell)
			if tile_id == 0:
				tilemap.set_cellv(cell, -1)
		
			set_collision_mask_bit(0,0)
			
			SoundFx.play("Hit", rand_range(.5, 1), -9)
			
			Global.instance_scene_on_main(tilehit, collision.position)

func _on_Hitbox_body_entered(_body):
	queue_free()


func _on_Hitbox_area_entered(_area):
	queue_free()
