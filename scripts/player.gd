extends CharacterBody2D
class_name Player

var speed = 200
var friction = 0.1
var acceleration = 0.1
var attack_cooldown = true
var attack_repr = preload("res://scenes/eldritch_blast.tscn")

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(_delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	attack()
	
func attack():
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	if Input.is_action_just_pressed("attack") and attack_cooldown:
		attack_cooldown = false
		var projectile = attack_repr.instantiate()
		projectile.rotation = $Marker2D.rotation
		projectile.global_position = $Marker2D.global_position
		get_tree().current_scene.add_child(projectile)
		await get_tree().create_timer(0.4).timeout
		attack_cooldown = true
