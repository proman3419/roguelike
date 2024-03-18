extends CharacterBody2D
class_name Enemy

var direction : Vector2 = Vector2()
var speed = 200
var friction = 0.1
var acceleration = 0.1
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@export var player : Player

#func _physics_process(delta):
	#direction = to_local(nav.target_position).normalized()
	#velocity = direction * speed
	#move_and_slide()
	
func _physics_process(_delta: float) -> void:
	var next_path_pos := nav.get_next_path_position()
	var dir := global_position.direction_to(next_path_pos)
	velocity = dir * speed
	move_and_slide()

func makepath():
	nav.target_position = player.global_position

func _on_timer_timeout():
	print("Sadsfsa")
	makepath()
