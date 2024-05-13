extends Node
class_name Hud


func update_health(health):
	$Health.text = "HP: " + str(health)


func update_gold(gold):
	$Gold.text = "GOLD: " + str(gold)


func show_game_over(gold, level):
	$Gold.visible = false
	$Health.visible = false
	$TransitionBackground.visible = true
	$GameOver.text = "[center]%s[/center]" % ["DEFEATED\nachieved level: " + str(level) + "\ncollected gold: " + str(gold)]


func update_level(level):
	$Level.text = "LEVEL: " + str(level)
