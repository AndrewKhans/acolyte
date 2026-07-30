class_name ItemStack

var item_texture: Texture2D
var block_tileset_coords: Vector2i
var count: int

func _init(
	_item_texture: Texture2D,
	_block_tileset_coords: Vector2i,
	_count: int
):
	self.item_texture = _item_texture
	self.block_tileset_coords = _block_tileset_coords
	self.count = _count

func primary_action():
	pass

func secondary_action():
	pass
