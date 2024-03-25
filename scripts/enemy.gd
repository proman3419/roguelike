extends CharacterBody2D
class_name Enemy

var direction : Vector2 = Vector2()
var speed = 50
var friction = 0.1
var acceleration = 0.1
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@export var player : Player
var health = 100
var damage = 10
var player_in_area = false
var dead = false

func _ready():
	get_node("Timer").timeout.connect(_on_timer_timeout)
	
func _physics_process(_delta: float) -> void:
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			makepath()
			move()
	else:
		$detection_area/CollisionShape2D.disabled = true

func move():
	var next_path_pos := nav.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos).normalized()
	velocity = dir * speed
	move_and_slide()

func makepath():
	nav.target_position = player.global_position

func _on_timer_timeout():
	#makepath()
	pass

func _on_detection_area_body_entered(body):
	print("DET AREA")
	if body is Player:
		player_in_area = true
		player = body

func _on_detection_area_body_exited(body):
	if body is Player:
		player_in_area = false

func _on_hitbox_body_entered(body):
	print("HITBOX")
	if body is Projectile:
		health -= body.damage
		body.queue_free()
		if health <= 0:
			dead = true
