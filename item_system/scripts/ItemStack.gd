class_name ItemStack

var item_texture: Texture2D
var count: int

func _init(_item_texture: Texture2D, _count: int):
	self.item_texture = _item_texture
	self.count = _count
	
@warning_ignore("unused_parameter")
func primary_action(target_loc: Vector2):
	pass
	
@warning_ignore("unused_parameter")
func secondary_action(target_loc: Vector2):
	pass
