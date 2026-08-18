class_name PlaceableItem extends ItemStack

var block_class = null

func secondary_action(target_loc: Vector2):
	var target_block = BlockSystem.world_coords_to_block_coords(target_loc)
	var placed = BlockSystem.instance.add_block(block_class.new(target_block))
	if placed:
		self.count -= 1
		AudioSystem.instance.block()
