class_name Shovel extends ItemStack

func _init():
	var item_texture = preload("res://sprites/items/ShovelItem.png")
	super(item_texture, 1)

func on_right_click():
	print_debug("Dig!")
