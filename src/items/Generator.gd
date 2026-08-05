class_name Generator extends PlaceableItem

func _init(_count: int):
	var item_texture = preload("res://sprites/items/GeneratorItem.png")
	self.block_class = GeneratorBlock
	super(item_texture, _count)
