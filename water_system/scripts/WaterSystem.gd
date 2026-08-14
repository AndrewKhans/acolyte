class_name WaterSystem extends TileMapLayer

const TILE_SIZE = 32

const LAKE_SOURCE_ID = 0
const CANAL_SOURCE_ID = 1

const STRAIGHT_COORDS = Vector2i(0,0)
const CURVE_COORDS = Vector2i(0,1)
const T_COORDS = Vector2i(0,2)
const FOURWAY_COORDS = Vector2i(0,3)
const END_COORDS = Vector2i(0,4)
const HOLE_COORDS = Vector2i(0,5)

const ROTATE_0   = 0
const ROTATE_90  = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H
const ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V
const ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V

static var instance: WaterSystem

static func world_coords_to_block_coords(mouseCoords: Vector2i) -> Vector2i:
	return Vector2i(
		floor(mouseCoords.x / TILE_SIZE),
		floor(mouseCoords.y / TILE_SIZE)
	)

# Singleton ready function
func _ready():
	instance = self

func add_canal(coords: Vector2i) -> bool:
	if get_cell_source_id(coords) != -1: return false
	
	update_canal_texture(coords)
	update_adjacent_canals(coords)
	BlockSystem.instance.update_adjacent_blocks(coords)
	return true

func update_canal_texture(coords: Vector2i) -> void:
	var left :=  0 if get_cell_source_id(Vector2i(coords.x - 1, coords.y)) == -1 else 1
	var right := 0 if get_cell_source_id(Vector2i(coords.x + 1, coords.y)) == -1 else 1
	var up :=    0 if get_cell_source_id(Vector2i(coords.x, coords.y - 1)) == -1 else 1
	var down :=  0 if get_cell_source_id(Vector2i(coords.x, coords.y + 1)) == -1 else 1
	var total := left + right + up + down

	var atlasCoords: Vector2i
	var rotKey: int
	match total:
		4:
			atlasCoords = FOURWAY_COORDS
			rotKey = ROTATE_0
		3:
			atlasCoords = T_COORDS
			if up == 0:      rotKey = ROTATE_0
			elif right == 0: rotKey = ROTATE_90
			elif down == 0:  rotKey = ROTATE_180
			elif left == 0:  rotKey = ROTATE_270
		2:
			atlasCoords = STRAIGHT_COORDS
			if left == 1 and right == 1: rotKey = ROTATE_0
			elif up == 1 and down == 1:  rotKey = ROTATE_90
			else:
				atlasCoords = CURVE_COORDS
				if left == 1 and down == 1:    rotKey = ROTATE_0
				elif left == 1 and up == 1:    rotKey = ROTATE_90
				elif up == 1 and right == 1:   rotKey = ROTATE_180
				elif right == 1 and down == 1: rotKey = ROTATE_270
		1:
			atlasCoords = END_COORDS
			if left == 1:    rotKey = ROTATE_0
			elif up == 1:    rotKey = ROTATE_90
			elif right == 1: rotKey = ROTATE_180
			elif down == 1:  rotKey = ROTATE_270
		0:
			atlasCoords = HOLE_COORDS
			rotKey = ROTATE_0
			
	set_cell(coords, CANAL_SOURCE_ID, atlasCoords, rotKey)

func update_adjacent_canals(coords: Vector2i) -> void:
	var neighbors := get_surrounding_cells(coords)
	for n in neighbors:
		if get_cell_source_id(n) == 1: update_canal_texture(n)

func has_adjacent_water(coords: Vector2i) -> bool:
	var neighbors := get_surrounding_cells(coords)
	for n in neighbors:
		if get_cell_source_id(n) != -1: return true
	return false
	
func remove_canal(coords: Vector2i) -> bool:
	if get_cell_source_id(coords) != CANAL_SOURCE_ID: return false
	
	set_cell(coords, -1)
	update_adjacent_canals(coords)
	BlockSystem.instance.update_adjacent_blocks(coords)
	return true
