extends Node
class_name Hud


var RNG = RandomNumberGenerator.new()
@onready var player: Player = get_parent().get_node("Player")
@onready var main: Main = get_parent()
var powerup_pressed = false
var powerup_names = ["health", "gold", "damage", "cooldown", "speed"]
var powerup_textures = [preload("res://assets/powerups/health.png"), 
						preload("res://assets/powerups/gold.png"),
						preload("res://assets/powerups/damage.png"),
						preload("res://assets/powerups/cooldown.png"),
						preload("res://assets/powerups/speed.png")]
var powerup_min_vals = [10, 10, 25, 0.1, 2]
var powerup_max_vals = [50, 200, 50, 0.4, 10]

var selected_powerup_is = [-1, -1, -1]
var selected_powerup_values = [0, 0, 0]


func _ready():
	set_background_alpha(0.5)


func set_background_alpha(a):
	$StatsBackground.modulate.a = a
	$GoldBackground.modulate.a = a
	$LevelBackground.modulate.a = a


func update_health(health):
	$HealthText.text = str(health)


func update_damage(damage):
	$DamageText.text = str(damage)
	

func update_cooldown(cooldown):
	$CooldownText.text = str(snapped(cooldown, 0.01))


func update_gold(gold):
	$GoldText.text = str(gold)


func update_speed(speed):
	$SpeedText.text = str(speed)


func show_game_over(gold, level):
	$Powerup1.visible = false
	$PowerupText1.visible = false
	$Powerup2.visible = false
	$PowerupText2.visible = false
	$Powerup3.visible = false
	$PowerupText3.visible = false
	$Gold.visible = false
	$GoldText.visible = false
	$Health.visible = false
	$HealthText.visible = false
	$Damage.visible = false
	$DamageText.visible = false
	$Cooldown.visible = false
	$CooldownText.visible = false
	$Speed.visible = false
	$SpeedText.visible = false
	$TransitionBackground.visible = true
	$PowerupNotification.visible = false
	$GameOver.text = "[center]%s[/center]" % ["DEFEATED\nachieved level: " + str(level) + "\ncollected gold: " + str(gold)]


func update_level(level):
	$Level.text = "[center]%s[/center]" % "LEVEL: " + str(level)


func next_level_transition():
	powerup_pressed = false
	$TransitionBackground.visible = true
	var selected = []
	select_random_powerup_with_value(0, selected)
	select_random_powerup_with_value(1, selected)
	select_random_powerup_with_value(2, selected)
	$PowerupNotification.visible = true
	$Powerup1.visible = true
	$PowerupText1.visible = true
	$Powerup2.visible = true
	$PowerupText2.visible = true
	$Powerup3.visible = true
	$PowerupText3.visible = true
	while not powerup_pressed:
		if get_tree() == null:
			break
		await get_tree().create_timer(1).timeout
	$Powerup1.visible = false
	$PowerupText1.visible = false
	$Powerup2.visible = false
	$PowerupText2.visible = false
	$Powerup3.visible = false
	$PowerupText3.visible = false
	$TransitionBackground.visible = false
	$PowerupNotification.visible = false


func select_random_powerup_with_value(powerup_slot, selected):
	var i: int
	var value: float
	while true:
		i = RNG.randi_range(0, len(powerup_names)-1)
		if i in selected:
			continue
		selected.append(i)
		value = RNG.randf_range(powerup_min_vals[i], powerup_max_vals[i])
		break
	if powerup_names[i] == "cooldown":
		value = snapped(value, 0.01)
	else:
		value = int(value)
	selected_powerup_is[powerup_slot] = i
	selected_powerup_values[powerup_slot] = value
	var texture = powerup_textures[i]
	match powerup_slot:
		0:
			$Powerup1.texture_normal = texture
			$PowerupText1.text = "[center]%s[/center]" % [str(value)]
		1:
			$Powerup2.texture_normal = texture
			$PowerupText2.text = "[center]%s[/center]" % [str(value)]
		2:
			$Powerup3.texture_normal = texture
			$PowerupText3.text = "[center]%s[/center]" % [str(value)]


func apply_powerup(powerup_slot):
	var i = selected_powerup_is[powerup_slot]
	var value = selected_powerup_values[powerup_slot]
	match powerup_names[i]:
		"health":
			player.increase_health(value)
		"damage":
			player.increase_damage(value)
		"gold":
			main.add_gold(value)
		"cooldown":
			player.lower_cooldown(value)
		"speed":
			player.increase_speed(value)


func _on_powerup_1_pressed():
	apply_powerup(0)
	powerup_pressed = true


func _on_powerup_2_pressed():
	apply_powerup(1)
	powerup_pressed = true


func _on_powerup_3_pressed():
	apply_powerup(2)
	powerup_pressed = true
