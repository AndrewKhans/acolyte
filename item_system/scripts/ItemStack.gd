class_name ItemStack

var item_texture: Texture2D
var ground_texture: Texture2D
var count: int

func _init(
	_item_texture: Texture2D,
	_world_texture: Texture2D,
	_count: int
):
	self.item_texture = _item_texture
	self.ground_texture = _world_texture
	self.count = _count

func on_left_click():
	pass

func on_right_click():
	pass
