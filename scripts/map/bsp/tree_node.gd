class_name TreeNode

var level: int
var left: TreeNode
var right: TreeNode
var x: int
var y: int
var x_margin: int
var y_margin: int
var width: int
var height: int

func _init(_level, _left, _right, _x, _y, _x_margin, _y_margin, _width, _height):
	self.level = _level
	self.left = _left
	self.right = _right
	self.x = _x
	self.y = _y
	self.x_margin = _x_margin # change to padding
	self.y_margin = _y_margin
	self.width = _width
	self.height = _height

func print():
	var format_str = "level: {level} | left: {left} | right: {right} | x: {x} | y: {y} | x_margin: {x_margin} | y_margin: {y_margin} | width: {width} | height: {height}"
	var actual_str = format_str.format({"level": level, "left": left, "right": right, "x": x, "y": y, "x_margin": x_margin, "y_margin": y_margin, "width": width, "height": height})
	print(actual_str)
