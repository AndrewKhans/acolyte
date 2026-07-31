extends TileMapLayer

var coords_to_block: Dictionary = {}

func _ready() -> void:
	pass

func get_block_obj(coords: Vector2i):
	return coords_to_block.get(coords, null)

func add_block(block: Block) -> void:
	coords_to_block[block.world_coords] = block

func remove_block(coords: Vector2i) -> void:
	coords_to_block.erase(coords)

func _process(delta: float) -> void:
	for block in coords_to_block.values():
		block.on_tick(delta)
