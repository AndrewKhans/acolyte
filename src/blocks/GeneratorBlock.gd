class_name GeneratorBlock extends Block

const TILESET_COORDS = Vector2i(0,1)
var hydrated = false

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)
	
func secondary_action(HUD: Control):
	pass
