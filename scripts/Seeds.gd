class_name Seeds extends ItemStack

func _init(_count: int):
	var item_texture = preload("res://sprites/items/SeedsItem.png")
	var block_tileset_coords = Vector2i(2,0)
	super(item_texture, block_tileset_coords, _count)

func secondary_action(Vector2i: targeted_square):
	 #Place seeds at target location
	print_debug("right clicked seeds")
	$BlockTileMap.add_block(SeedsBlock(targeted_square))
	func add_block(coords: Vector2i, block) -> void:
