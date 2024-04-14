extends Projectile
class_name EldritchBlast

func _ready():
	speed = 300
	damage = 25
	range = 100
	spawn_position = global_position
	damage_player = false
	damage_enemy = true
