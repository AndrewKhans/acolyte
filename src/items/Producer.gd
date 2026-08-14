class_name Producer extends PlaceableItem

func _init(_count: int):
	var item_texture = preload("res://sprites/items/ProducerItem.png")
	self.block_class = ProducerBlock
	super(item_texture, _count)
