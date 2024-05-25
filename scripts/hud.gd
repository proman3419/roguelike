extends Node
class_name Hud


var RNG = RandomNumberGenerator.new()
@onready var player: Player = get_parent().get_node("Player")
@onready var main: Main = get_parent()
var powerup_pressed = false
var powerup_names = ["health", "gold", "attack damage"]
var powerup_textures = [preload("res://assets/tiles/health.png"), 
						preload("res://assets/tiles/gold.png"),
						preload("res://assets/tiles/door.png")]
var powerup_min_vals = [1, 10, 5]
var powerup_max_vals = [50, 9999, 25]

var selected_powerup_is = [-1, -1, -1]
var selected_powerup_values = [0, 0, 0]


func update_health(health):
	$Health.text = "HP: " + str(health)


func update_gold(gold):
	$Gold.text = "GOLD: " + str(gold)


func show_game_over(gold, level):
	$Powerup1.visible = false
	$Powerup2.visible = false
	$Powerup3.visible = false
	$Gold.visible = false
	$Health.visible = false
	$TransitionBackground.visible = true
	$GameOver.text = "[center]%s[/center]" % ["DEFEATED\nachieved level: " + str(level) + "\ncollected gold: " + str(gold)]


func update_level(level):
	$Level.text = "LEVEL: " + str(level)


func next_level_transition():
	powerup_pressed = false
	$TransitionBackground.visible = true
	select_random_powerup_with_value(0)
	select_random_powerup_with_value(1)
	select_random_powerup_with_value(2)	
	$Powerup1.visible = true
	$Powerup2.visible = true
	$Powerup3.visible = true
	while not powerup_pressed:
		await get_tree().create_timer(1).timeout
	$Powerup1.visible = false
	$Powerup2.visible = false
	$Powerup3.visible = false
	$TransitionBackground.visible = false


func select_random_powerup_with_value(powerup_slot):
	var i = RNG.randi_range(0, len(powerup_names)-1)
	var value = RNG.randf_range(powerup_min_vals[i], powerup_max_vals[i])
	selected_powerup_is[powerup_slot] = i
	selected_powerup_values[powerup_slot] = value
	var texture = powerup_textures[i]
	match powerup_slot:
		0:
			$Powerup1.texture_normal = texture
		1:
			$Powerup2.texture_normal = texture
		2:
			$Powerup3.texture_normal = texture


func apply_powerup(powerup_slot):
	var i = selected_powerup_is[powerup_slot]
	var value = selected_powerup_values[i]
	match powerup_names[i]:
		"health":
			player.increase_health(value)
		"attack damage":
			player.increase_attack_damage(value)
		"gold":
			main.add_gold(value)

func _on_powerup_1_pressed():
	apply_powerup(0)
	powerup_pressed = true


func _on_powerup_2_pressed():
	apply_powerup(1)
	powerup_pressed = true


func _on_powerup_3_pressed():
	apply_powerup(2)
	powerup_pressed = true
