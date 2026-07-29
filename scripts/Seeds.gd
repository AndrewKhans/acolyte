class_name Seeds extends ItemStack

func _init(_count: int):
	var item_texture = preload("res://sprites/items/SeedsItem.png")
	var tile_texture = preload("res://sprites/items/SeedsTile.png")
	super(item_texture, tile_texture, _count)
