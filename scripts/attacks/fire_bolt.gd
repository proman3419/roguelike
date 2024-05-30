extends Projectile
class_name FireBolt

func _ready():
	setup_signals()
	speed = 300
	damage = 15
	cooldown = 1.5
	travel_range = 200
	spawn_position = global_position
	damage_player = true
	damage_enemy = false
