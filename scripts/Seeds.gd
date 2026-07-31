class_name Seeds extends ItemStack

func _init(_count: int):
	var item_texture = preload("res://sprites/items/SeedsItem.png")
	super(item_texture, _count)

func secondary_action(target_loc: Vector2):
	var target_block = BlockSystem.world_coords_to_block_coords(target_loc)
	var placed = BlockSystem.instance.add_block(SeedsBlock.new(target_block))
	if placed: self.count -= 1
