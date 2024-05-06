extends Node2D
class_name Rooms

const SPAWN_ROOMS: Array = [preload("res://scenes/map/spawn_room.tscn")]
const NORMAL_ROOMS: Array = [preload("res://scenes/map/normal_room.tscn")]
#const SPECIAL_ROOMS: Array = [preload("res://Rooms/SpecialRoom0.tscn"), preload("res://Rooms/SpecialRoom1.tscn")]
#const END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]
#const SLIME_BOSS_SCENE: PackedScene = preload("res://Rooms/SlimeBossRoom.tscn")

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 2
const RIGHT_WALL_TILE_INDEX: int = 6
const LEFT_WALL_TILE_INDEX: int = 6

@export var num_levels: int = 5

@onready var player: CharacterBody2D = get_parent().get_node("Player")


func _ready() -> void:
	_spawn_rooms()


func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false

	for i in num_levels:
		var room: Node2D

		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			#if i == num_levels - 1:
				#room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			#else:
			#if (randi() % 3 == 0 and not special_room_spawned) or (i == num_levels - 2 and not special_room_spawned):
				#room = SPECIAL_ROOMS[randi() % SPECIAL_ROOMS.size()].instantiate()
				#special_room_spawned = true
			#else:
			room = NORMAL_ROOMS[randi() % NORMAL_ROOMS.size()].instantiate()

			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2

			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height:
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-2, -y+1), LEFT_WALL_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y+1), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y+1), FLOOR_TILE_INDEX, Vector2i.ZERO)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(1, -y+1), RIGHT_WALL_TILE_INDEX, Vector2i.ZERO)

			var room_tilemap: TileMap = room.get_node("TileMap")
			room.position = previous_room_door.global_position + \
				Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + \
				Vector2.UP * (corridor_height) * TILE_SIZE + \
				Vector2.LEFT * (room.get_node("Entrance/Position2D2").position.x - 3) * TILE_SIZE
				
		add_child(room)
		previous_room = room
