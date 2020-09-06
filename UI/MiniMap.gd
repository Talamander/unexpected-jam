extends MarginContainer

export(NodePath) var player

export var zoom = 1.5

onready var grid = $Grid
onready var player_marker = $Grid/PlayerMarker
onready var enemy_marker = $Grid/EnemyMarker

onready var icons = {"Enemy": enemy_marker}

var grid_scale
var markers = {}

var previous_object_count = 0
var object_count = 1

func _ready():
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)

func _process(delta):
	if !player:
		return
	player_marker.rotation = get_node(player).rotation + PI / 2
	
	
	add_map_object()
	
	update_map()


func add_map_object():
	var map_objects = get_tree().get_nodes_in_group("minimap_object")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker

func update_map():
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.rect_size / 2
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(.4, .4)
		else:
			markers[item].scale = Vector2(.2, .2)
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		markers[item].position = obj_pos
		

func _on_object_removed(object):
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)
