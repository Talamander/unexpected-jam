extends MarginContainer

export(NodePath) var player

export var zoom = 1.5

onready var grid = $Grid
onready var player_marker = $Grid/PlayerMarker
onready var enemy_marker = $Grid/EnemyMarker
onready var item_marker = $Grid/PlayerMarker

onready var icons = {"Enemy": enemy_marker, "Pickup": item_marker}

var grid_scale
var markers = {}

var previous_object_count = 0
var object_count = 1

func _ready():
# warning-ignore-all:return_value_discarded
	SignalManager.connect("enemy_spawned", self, "_add_map_object")
	SignalManager.connect("enemy_despawn", self, "_on_object_removed")
	SignalManager.connect("item_spawn", self, "_add_map_object")
	SignalManager.connect("item_despawn", self, "_on_object_removed")
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)

# warning-ignore:unused_argument
func _process(delta):
	if !player:
		return
	if Global.currentModifier == "noMiniMap":
		self.visible = false
	elif Global.currentModifier != "noMiniMap":
		self.visible = true
	if Global.player != null:
		player_marker.rotation = get_node(player).rotation + PI / 2
	
	
	update_map()


func _add_map_object(enemy):
	print("triggered")
	#var map_objects = get_tree().get_nodes_in_group("minimap_object")
	#for item in map_objects:
	var new_marker = icons[enemy.minimap_icon].duplicate()
	grid.add_child(new_marker)
	new_marker.show()
	markers[enemy] = new_marker

func update_map():
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.rect_size / 2
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(.2, .2)
		else:
			markers[item].scale = Vector2(.15, .15)
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		markers[item].position = obj_pos
		

func _on_object_removed(enemy):
	markers[enemy].queue_free()
	markers.erase(enemy)
