class_name Shovel extends ItemStack

func _init(_count: int):
	var item_texture = preload("res://sprites/items/ShovelItem.png")
	super(item_texture, null, _count)

func on_right_click():
	print_debug("Dig!")
