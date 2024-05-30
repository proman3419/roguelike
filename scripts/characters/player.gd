extends CharacterBody2D
class_name Player

var health = 100
var speed = 100
var friction = 0.1
var acceleration = 0.1
var attack_cooldown = true
var attack_repr = preload("res://scenes/attacks/eldritch_blast.tscn")
var damage = 25
var cooldown = 0.5
var _rotation
var _rotation_degrees
@onready var hud: Hud = get_parent().get_node("Hud")
@onready var main: Main = get_parent()

func _ready():
	hud.update_health(health)

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
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	_rotation_degrees = $Marker2D.rotation_degrees
	var face_cursor_degrees = _rotation_degrees - 90
	$CollisionShape2D.rotation_degrees = face_cursor_degrees
	$Sprite2D.rotation_degrees = face_cursor_degrees
	$hitbox.rotation_degrees = face_cursor_degrees
	$AttackSpawn.rotation_degrees = face_cursor_degrees
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	attack()
	
func attack():
	if Input.is_action_just_pressed("attack") and attack_cooldown:
		attack_cooldown = false
		var projectile = attack_repr.instantiate()
		projectile.damage = damage # not working :)
		projectile.cooldown = cooldown # same
		projectile.rotation = $Marker2D.rotation
		projectile.global_position = $AttackSpawn.global_position
		get_tree().current_scene.add_child(projectile)
		await get_tree().create_timer(cooldown).timeout
		attack_cooldown = true

func _on_hitbox_area_entered(area):
	if area is Projectile and area.damage_player:
		health -= area.damage
		area.queue_free()
		if health <= 0:
			main.game_over = true
			hud.show_game_over(main.gold, main.level)
		hud.update_health(health)

func increase_damage(value):
	damage += value
	hud.update_damage(value)

func increase_health(value):
	health += value
	hud.update_health(health)

func lower_cooldown(value):
	cooldown *= 1 - value
	hud.update_cooldown(cooldown)
