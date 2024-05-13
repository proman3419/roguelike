extends Projectile
class_name EldritchBlast

func _ready():
	setup_signals()
	speed = 300
	damage = 100
	cooldown = 0.3
	travel_range = 100
	spawn_position = global_position
	damage_player = false
	damage_enemy = true
