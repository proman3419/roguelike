extends CharacterBody2D
class_name Player

var health = 100
var speed = 200
var friction = 0.1
var acceleration = 0.1
var attack_cooldown = true
var attack_repr = preload("res://scenes/attacks/eldritch_blast.tscn")
var attack_damage = 25
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
	_rotation = $Marker2D.rotation
	_rotation_degrees = $Marker2D.rotation_degrees
	$CollisionShape2D.rotation = _rotation
	$Sprite2D.rotation = _rotation
	$hitbox.rotation = _rotation
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
		projectile.damage = attack_damage
		projectile.rotation = $Marker2D.rotation
		projectile.global_position = $Marker2D.global_position
		get_tree().current_scene.add_child(projectile)
		await get_tree().create_timer(projectile.cooldown).timeout
		attack_cooldown = true

func _on_hitbox_area_entered(area):
	if area is Projectile and area.damage_player:
		health -= area.damage
		area.queue_free()
		if health <= 0:
			hud.show_game_over(main.gold, main.level)
		hud.update_health(health)

func increase_attack_damage(value):
	attack_damage += value

func increase_health(value):
	health += value
