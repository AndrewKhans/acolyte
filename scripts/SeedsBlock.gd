class_name SeedsBlock extends Block

var growthPoints = 0
var hydrated = false
var _tileset_coords = Vector2i(2,0)

func _init():
	super(_tileset_coords)

func on_tick(delta: float) -> void:
	growthPoints += 1
