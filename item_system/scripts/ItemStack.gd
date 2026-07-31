class_name ItemStack

var item_texture: Texture2D
var count: int

func _init(
	_item_texture: Texture2D,
	_count: int
):
	self.item_texture = _item_texture
	self.count = _count
	
func primary_action(target_loc: Vector2):
	pass
	
func secondary_action(target_loc: Vector2):
	pass
