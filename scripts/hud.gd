extends Node
class_name Hud


func update_health(health):
	$Health.text = str(health)

func update_gold(gold):
	$Gold.text = str(gold)

func show_game_over(gold):
	$Gold.visible = false
	$Health.visible = false
	$GameOver.text = "                You died\ncollected " + str(gold) + " gold pieces"
