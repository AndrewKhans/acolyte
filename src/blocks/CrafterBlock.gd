class_name CrafterBlock extends Block

const TILESET_COORDS = Vector2i(1,0)

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)
	
func secondary_action(player: CharacterBody2D, HUD: Control):
	HUD.show_crafter_ui(player, self)
	return true
