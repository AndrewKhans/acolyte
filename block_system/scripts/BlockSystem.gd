class_name BlockSystem extends TileMapLayer

const TILE_SIZE = 32

var coords_to_block: Dictionary

static var instance: BlockSystem


static func world_coords_to_block_coords(mouseCoords: Vector2i) -> Vector2i:
	return Vector2i(
		floor(mouseCoords.x / TILE_SIZE),
		floor(mouseCoords.y / TILE_SIZE)
	)

static func block_coords_to_world_coords(blockCoords: Vector2i) -> Vector2i:
	var ret = (blockCoords * TILE_SIZE)
	ret.x += TILE_SIZE/2
	ret.y += TILE_SIZE/2
	return ret

# Singleton ready function
func _ready(): instance = self

func _init() -> void:
	coords_to_block = {}

func get_block_obj(coords: Vector2i) -> Block:
	return coords_to_block.get(coords, null)

func add_block(block: Block) -> bool:
	# Can't add block if there's already a block there
	if get_cell_source_id(block.world_coords) != -1: return false
	if WaterSystem.instance.get_cell_source_id(block.world_coords) != -1: return false
	
	coords_to_block[block.world_coords] = block
	set_cell(block.world_coords, 0, block.tileset_coords)
	update_adjacent_blocks(block.world_coords)
	return true

func remove_block(coords: Vector2i) -> void:
	coords_to_block.erase(coords)
	set_cell(coords, -1)

func update_adjacent_blocks(worldCoords: Vector2i) -> void:
	for p in get_surrounding_cells(worldCoords):
		if get_block_obj(p) != null: get_block_obj(p).update()

func tick_blocks() -> void:
	for block in coords_to_block.values():
		block.on_tick()
