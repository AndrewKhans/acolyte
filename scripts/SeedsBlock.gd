class_name SeedsBlock extends Block

const TILESET_COORDS = Vector2i(2,0)

var growthPoints = 0
var hydrated = false

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)
	
func on_tick(delta: float) -> void:
	growthPoints += 1
