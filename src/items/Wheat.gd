class_name Wheat extends ItemStack

func _init(_count: int):
	var item_texture = preload("res://sprites/items/WheatItem.png")
	super(item_texture, _count)
