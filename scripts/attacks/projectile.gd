extends Area2D
class_name Projectile

var damage: int
var speed: int
var cooldown: float
var travel_range: int
var spawn_position: Vector2
var damage_player: bool
var damage_enemy: bool

func _process(delta):
	position += (Vector2.RIGHT * get_dist(delta)).rotated(rotation)

func get_dist(delta):
	var dist_left = travel_range - position.distance_to(spawn_position)
	if dist_left <= 0.01:
		queue_free()
	var dist = speed * delta
	if dist >= dist_left:
		dist = dist_left
	return dist

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func setup_signals():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is TileMap:
		queue_free()
