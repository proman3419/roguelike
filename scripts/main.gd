extends Node
class_name Main


@onready var tile_map: TileMap = get_node("TileMap")
@onready var player: Player = get_node("Player")
@onready var hud: Hud = get_node("Hud")

const ENEMY_SCENES: Dictionary = {
	"SLIME": preload("res://scenes/characters/enemy.tscn")
}

var WIDTH = 40
var HEIGHT = 30
var FLOOR_TILE_ID = 2
var WALL_TILE_ID = 6
var TILE_SIZE = 16
var RNG = RandomNumberGenerator.new()
var WANDERS_CNT = 1000
var MAX_WANDER_DISTANCE = 1000
var MIN_ENEMY_SPAWN_DISTANCE = 5

var level = 1
var enemies_cnt = 0
var gold = 0
var game_over = false


func _ready() -> void:
	level_init()


func _on_enemy_killed() -> void:
	enemies_cnt -= 1
	add_gold(level * 10)
	if enemies_cnt == 0 and not game_over:
		level_up()


func spawn_basic_map():
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var tile_id = FLOOR_TILE_ID
			if x == 0 || y == 0 || x == WIDTH-1 || y == HEIGHT-1 || RNG.randf() < 0.01:
				tile_id = WALL_TILE_ID
			tile_map.set_cell(0, Vector2i(x, y), tile_id, Vector2i.ZERO)


func generate_map():
	# 0 - floor
	# 1 - wall
	var map = []
	for x in range(WIDTH):
		map.append([])
		for y in range(HEIGHT):
			map[x].append(1)
	
	var path = []
	wander(map, path, WIDTH/2, HEIGHT/2)
	for i in range(WANDERS_CNT):
		var path_elem = path[RNG.randi_range(0, len(path)-1)]
		wander(map, path, path_elem[0], path_elem[1])

	#for x in range(WIDTH):
		#print(map[x])
	
	return [map, path]


func spawn_map(map):
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var tile_id = FLOOR_TILE_ID
			if x == 0 || y == 0 || x == WIDTH-1 || y == HEIGHT-1 || map[x][y] == 1:
				tile_id = WALL_TILE_ID
			tile_map.set_cell(0, Vector2i(x, y), tile_id, Vector2i.ZERO)


func wander(map, path, x, y):
	for i in range(MAX_WANDER_DISTANCE):
		var direction = RNG.randf()
		if direction < 0.25: # up
			y -= 1
		elif direction < 0.5: # right
			x += 1
		elif direction < 0.75: # down
			y += 1
		else: # left
			x -= 1
		if x == 0 || y == 0 || x == WIDTH-1 || y == HEIGHT-1 || path.has([x, y]):
			break
		path.append([x, y])
		map[x][y] = 0


func spawn_player():
	player.position = Vector2(WIDTH/2*TILE_SIZE, HEIGHT/2*TILE_SIZE)


func spawn_enemies(path, enemies_to_spawn):
	while enemies_cnt < enemies_to_spawn:
		if len(path) == 0:
			print("Not enough space to spawn all enemies")
			return
		var path_i = RNG.randi_range(0, len(path)-1)
		var path_elem = path[path_i]
		if get_distance_to_player_spawn(path_elem[0], path_elem[1]) > MIN_ENEMY_SPAWN_DISTANCE:
			spawn_enemy(path_elem[0] * TILE_SIZE, path_elem[1] * TILE_SIZE)
			enemies_cnt += 1
		path.remove_at(path_i)


func get_distance_to_player_spawn(x, y):
	return sqrt(pow(x - WIDTH/2, 2) + pow(y - HEIGHT/2, 2))


func spawn_enemy(x, y):
	var enemy: CharacterBody2D
	enemy = ENEMY_SCENES.SLIME.instantiate()
	enemy.position = Vector2(x, y)
	call_deferred("add_child", enemy)


func level_up():
	level += 1
	hud.next_level_transition()
	while not hud.powerup_pressed:
		if get_tree() == null:
			break
		await get_tree().create_timer(1).timeout
	level_init()


func level_init():
	hud.update_gold(gold)
	hud.update_level(level)
	hud.update_cooldown(player.cooldown)
	hud.update_damage(player.damage)
	spawn_player()
	var generate_map_res = generate_map()
	var map = generate_map_res[0]
	var path = generate_map_res[1]
	spawn_map(map)
	spawn_enemies(path, level * 2)


func range_to_array(range):
	var array = []
	for i in range:
		array.append(i)
	return array


func add_gold(value):
	gold += value
	hud.update_gold(gold)
