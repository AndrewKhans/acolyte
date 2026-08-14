class_name ProducerBlock extends Block

const TILESET_COORDS = Vector2i(1,1)
const ALT_TILESET_COORDS = Vector2i(3,1)
const MAX_IRON = 1
const PROCESS_TIME_TICKS = 120

var hydrated := false
var powered := false
var running := false
var hasIron := false
var hasArtifact := false
var processingCompleted := 0

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)

func secondary_action(player: CharacterBody2D, HUD: Control):
	HUD.show_producer_ui(player, self)
	return true

func on_tick() -> void:
	update_powered_status()

	running = hydrated and powered and hasIron
	
	if running: processingCompleted += 1
	
	if processingCompleted >= PROCESS_TIME_TICKS:
		hasIron = false
		hasArtifact = true
		processingCompleted = 0
	
	if hasArtifact:
		BlockSystem.instance.set_cell(world_coords, 0, ALT_TILESET_COORDS)
	else:
		BlockSystem.instance.set_cell(world_coords, 0, TILESET_COORDS)


func update() -> void:
	self.hydrated = WaterSystem.instance.has_adjacent_water(self.world_coords)

func update_powered_status() -> void:
	for loc in BlockSystem.instance.get_surrounding_cells(self.world_coords):
		var block = BlockSystem.instance.get_block_obj(loc)
		if block != null and block.get_script().get_global_name() == "GeneratorBlock":
			if block.running:
				self.powered = true
				return
	self.powered = false
