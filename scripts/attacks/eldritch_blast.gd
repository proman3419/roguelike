extends Projectile
class_name EldritchBlast

func _ready():
	setup_signals()
	speed = 300
	damage = 25
	travel_range = 100
	spawn_position = global_position
	damage_player = false
	damage_enemy = true
	#print(get_node("Area2D"))
	#self.body_entered.connect(_on_body_entered)
	
#func _on_body_entered(body):
	#if body is TileMap:
		#queue_free()
