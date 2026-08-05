class_name Seeds extends PlaceableItem

func _init(_count: int):
	var item_texture = preload("res://sprites/items/SeedsItem.png")
	self.block_class = SeedsBlock
	super(item_texture, _count)
