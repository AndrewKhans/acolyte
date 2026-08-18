class_name Shovel extends ItemStack

func _init():
	var item_texture = preload("res://sprites/items/ShovelItem.png")
	super(item_texture, 1)

func primary_action(target_loc: Vector2):
	var blockCoords := BlockSystem.world_coords_to_block_coords(target_loc)
	if BlockSystem.instance.get_cell_source_id(blockCoords) == -1 \
	and WaterSystem.instance.has_adjacent_water(blockCoords):
		WaterSystem.instance.add_canal(blockCoords)
		AudioSystem.instance.block()
	
func secondary_action(target_loc: Vector2):
		var blockCoords := BlockSystem.world_coords_to_block_coords(target_loc)
		WaterSystem.instance.remove_canal(blockCoords)
		AudioSystem.instance.iron()
