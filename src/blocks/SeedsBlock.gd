class_name SeedsBlock extends Block

const TILESET_COORDS = Vector2i(2,0)
const TICKS_PER_GROWTH = 60*25

var timeUntilGrown = TICKS_PER_GROWTH
var hydrated = false

func _init(worldCoords: Vector2i):
	timeUntilGrown -= randi_range(0, 60*5)
	super(TILESET_COORDS, worldCoords)
	
func on_tick() -> void:
	timeUntilGrown -= 1
	if timeUntilGrown <= 0:
		var wheat := WheatBlock.new(self.world_coords)
		BlockSystem.instance.remove_block(self.world_coords)
		BlockSystem.instance.add_block(wheat)
	
