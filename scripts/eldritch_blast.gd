extends Projectile
class_name EldritchBlast

#var repr = load("res://assets/eldritch_blast.png")
#@onready var aim_pos = null
#@onready var self_pos = null
#
#func fire():
	#var velocity = Vector2()
	#var projectile = repr.instance()
	#projectile.add_collision_exception_with()

func _ready():
	speed = 300
	damage = 25
	set_as_top_level(true)

func _process(delta):
	position += (Vector2.RIGHT * speed).rotated(rotation) * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
