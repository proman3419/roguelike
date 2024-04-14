extends Area2D
class_name Projectile

var damage: int
var speed: int
var range: int
var spawn_position: Vector2
var damage_player: bool
var damage_enemy: bool

func _process(delta):
	position += (Vector2.RIGHT * get_dist(delta)).rotated(rotation)

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func get_dist(delta):
	var dist_left = range - position.distance_to(spawn_position)
	if dist_left <= 0.01:
		queue_free()
	var dist = speed * delta
	if dist >= dist_left:
		dist = dist_left
	return dist

static func spawn(projectile, tree):
	tree.current_scene.add_child(projectile)
	await tree.create_timer(0.4).timeout
