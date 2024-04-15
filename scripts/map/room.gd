extends RigidBody2D

var size

func make_room(_position, _size):
	position = _position
	size = _size
	var s = RectangleShape2D.new()
	s.size = size
	$CollisionShape2D.shape = s
