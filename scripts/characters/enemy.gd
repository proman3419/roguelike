extends CharacterBody2D
class_name Enemy

var direction : Vector2 = Vector2()
var speed = 50
var friction = 0.1
var acceleration = 0.1
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var player: Player = get_parent().get_node("Player")
var health = 100
var damage = 10
var player_detection_area_enabled = false
var player_in_detection_area = false
var dead = false
var attack_dist = 25
var attack_repr = preload("res://scenes/attacks/slash.tscn")
var attack_cooldown = true

func _ready():
	get_node("Timer").timeout.connect(_on_timer_timeout)
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
	
func _physics_process(_delta: float) -> void:
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_detection_area || !player_detection_area_enabled:
			makepath()
			move()
			if global_position.distance_to(player.position) <= attack_dist:
				if attack_cooldown:
					attack()
	else:
		$detection_area/CollisionShape2D.disabled = true

func move():
	rotation = global_position.angle_to_point(player.position)
	global_position = global_position
	var next_path_pos := nav.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos).normalized()
	velocity = dir * speed
	move_and_slide()

func makepath():
	nav.target_position = player.global_position
	
func attack():
	attack_cooldown = false
	var projectile = attack_repr.instantiate()
	projectile.rotation = rotation
	projectile.global_position = global_position
	get_tree().current_scene.add_child(projectile)
	await get_tree().create_timer(projectile.cooldown).timeout
	attack_cooldown = true

func _on_timer_timeout():
	#makepath()
	pass

func _on_detection_area_body_entered(body):
	if body is Player:
		player_in_detection_area = true
		player = body

func _on_detection_area_body_exited(body):
	if body is Player:
		player_in_detection_area = false

func _on_hitbox_area_entered(area):
	if area is Projectile and area.damage_enemy:
		health -= player.damage # :)
		area.queue_free()
		if health <= 0:
			dead = true
			queue_free()
