extends Projectile
class_name Slash

func _ready():
	speed = 300
	damage = 30
	cooldown = 0.5
	travel_range = 100
	spawn_position = global_position
	damage_player = true
	damage_enemy = false
