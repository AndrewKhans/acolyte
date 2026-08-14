class_name IronIngot extends ItemStack

func _init(_count: int):
	var item_texture = preload("res://sprites/items/IronIngotItem.png")
	super(item_texture, _count)
