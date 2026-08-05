class_name BlockSystem extends TileMapLayer

const TILE_SIZE = 32
static var instance: BlockSystem
var coords_to_block: Dictionary

static func world_coords_to_block_coords(mouseCoords: Vector2i) -> Vector2i:
	return Vector2i(
		floor(mouseCoords.x / TILE_SIZE),
		floor(mouseCoords.y / TILE_SIZE)
	)

# Singleton ready function
func _ready():
	instance = self

func _init() -> void:
	self.coords_to_block = {}

func get_block_obj(coords: Vector2i) -> Block:
	return self.coords_to_block.get(coords, null)

func add_block(block: Block) -> bool:
	# Can't add block if there's already a block there
	if self.get_cell_source_id(block.world_coords) != -1: return false
	
	self.coords_to_block[block.world_coords] = block
	self.set_cell(block.world_coords, 0, block.tileset_coords)
	return true

func remove_block(coords: Vector2i) -> void:
	self.coords_to_block.erase(coords)

func _process(delta: float) -> void:
	for block in self.coords_to_block.values():
		block.on_tick(delta)
