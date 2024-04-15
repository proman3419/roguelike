class_name BSP

const MARGIN_PERC = 0.15
var dungeon_width: int
var dungeon_height: int
var target_levels: int
var tree_root: TreeNode
var rng: RandomNumberGenerator

func _init(_dungeon_width, _dungeon_height, _target_levels):
	self.dungeon_width = _dungeon_width
	self.dungeon_height = _dungeon_height
	self.target_levels = _target_levels
	self.tree_root = TreeNode.new(0, null, null, 0, 0, 0, 0, dungeon_width, dungeon_height)
	self.rng = RandomNumberGenerator.new()

func generate(node):
	if node.level < target_levels:
		#_level, _left, _right, _x, _y, _x_margin, _y_margin, _width, _height
		var level = node.level + 1
		var split_horizontally = rng.randf_range(0, 100) > 50
		var split_ratio = rng.randf()
		print(split_ratio)
		if split_horizontally:
			var w_l = int(split_ratio * node.width)
			node.left = TreeNode.new(level, null, null, node.x, node.y, get_random_margin(w_l, MARGIN_PERC), node.y_margin, w_l, node.height)
			generate(node.left)
			var w_r = node.width - w_l
			node.right = TreeNode.new(level, null, null, node.x + w_l, node.y, get_random_margin(w_r, MARGIN_PERC), node.y_margin, w_r, node.height)
			generate(node.right)
		else:
			var h_l = int(split_ratio * node.height)
			node.left = TreeNode.new(level, null, null, node.x, node.y, node.x_margin, get_random_margin(h_l, MARGIN_PERC), node.width, h_l)
			generate(node.left)
			var h_r = node.height - h_l
			node.right = TreeNode.new(level, null, null, node.x, node.y + h_l, node.x_margin, get_random_margin(h_r, MARGIN_PERC), node.width, h_r)
			generate(node.right)

func get_random_margin(x, max_x_perc):
	return int(rng.randf_range(0, x * max_x_perc))

func get_leafs(node):
	if node.left == null and node.right == null:
		return [node]
	else:
		var leafs = []
		if node.left != null:
			leafs += get_leafs(node.left)
		if node.right != null:
			leafs += get_leafs(node.right)
		return leafs

func print_rooms(node):
	node.print()
	if node.left != null:
		print_rooms(node.left)
	if node.right != null:
		print_rooms(node.right)
