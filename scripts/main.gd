extends Node


@onready var tile_map: TileMap = get_node("TileMap")
@onready var player: Player = get_node("Player")

const ENEMY_SCENES: Dictionary = {
	"SLIME": preload("res://scenes/characters/enemy.tscn")
}

var WIDTH = 30
var HEIGHT = 40
var FLOOR_TILE_ID = 2
var WALL_TILE_ID = 6
var TILE_SIZE = 16

var level = 0
var enemies_cnt = 0

func _ready() -> void:
	spawn_player()
	create_map()
	#while true:
	spawn_enemies((level + 1) * 2)
		#while enemies_cnt > 0:
			#pass


func _on_enemy_killed() -> void:
	enemies_cnt -= 1
	if enemies_cnt == 0:
		level_up()


func create_map():
	for x in range(WIDTH):
		for y in range(HEIGHT):
			if x == 0 || y == 0 || x == WIDTH-1 || y == HEIGHT-1:
				tile_map.set_cell(0, Vector2i(x, y), WALL_TILE_ID, Vector2i.ZERO)
			else:
				tile_map.set_cell(0, Vector2i(x, y), FLOOR_TILE_ID, Vector2i.ZERO)


func spawn_player():
	player.position = Vector2(WIDTH/2*TILE_SIZE, HEIGHT/2*TILE_SIZE)


func spawn_enemies(enemies_to_spawn):
	var x_coords = range_to_array(range(1, WIDTH-1))
	x_coords.shuffle()
	var y_coords = range_to_array(range(1, HEIGHT-1))
	y_coords.shuffle()
	for i in range(enemies_to_spawn):
		spawn_enemy(x_coords[i] * TILE_SIZE, y_coords[i] * TILE_SIZE)
		enemies_cnt += 1


func spawn_enemy(x, y):
	var enemy: CharacterBody2D
	print(x, y)
	enemy = ENEMY_SCENES.SLIME.instantiate()
	enemy.position = Vector2(x, y)
	call_deferred("add_child", enemy)


func level_up():
	level += 1
	spawn_enemies((level + 1) * 2)
	

func range_to_array(range):
	var array = []
	for i in range:
		array.append(i)
	return array
