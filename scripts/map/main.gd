extends Node2D

var room = preload("res://scenes/map/room.tscn")

var tile_size = 16
var num_rooms = 50
var min_size = 4
var max_size = 10
var bsp: BSP

func _ready():
	randomize()
	bsp = BSP.new(50, 50, 3)
	bsp.generate(bsp.tree_root)
	#bsp.print_rooms(bsp.tree_root)
	var leafs = bsp.get_leafs(bsp.tree_root)
	for r in leafs:
		r.print()
	make_rooms(leafs)
	
func make_rooms(tree_nodes):
	for tree_node in tree_nodes:
		var r = room.instantiate()
		r.make_room(Vector2(tree_node.x, tree_node.y), Vector2(tree_node.width, tree_node.height) * tile_size)
		$Rooms.add_child(r)
