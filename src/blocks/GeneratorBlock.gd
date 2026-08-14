class_name GeneratorBlock extends Block

const TILESET_COORDS = Vector2i(0,1)
const BURN_TICKS_PER_WHEAT = 120
const MAX_WHEAT = 10

var hydrated: bool = false
var running: bool = false
var wheatCount: int = 0
var burnTicksRemaining: int = 0

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)
	
func secondary_action(player: CharacterBody2D, HUD: Control):
	HUD.show_generator_ui(player, self)
	return true

func on_tick() -> void:
	if not hydrated: return
	
	if running:
		burnTicksRemaining -= 1
		if burnTicksRemaining <= 0: # This wheat is done
			wheatCount -= 1
			if wheatCount <= 0:
				running = false
			else:
				burnTicksRemaining = BURN_TICKS_PER_WHEAT
	else:
		if wheatCount > 0:
			burnTicksRemaining = BURN_TICKS_PER_WHEAT
			running = true
	
	#if burnTicksRemaining <= 0:
		#if wheatCount <= 0:
			#running = false
			#return
		#else:
			## If we are running, 
			#if running:
				#wheatCount -= 1
			#burnTicksRemaining = BURN_TICKS_PER_WHEAT
			#running = true
	#
	#burnTicksRemaining -= 1

func update() -> void:
	# Check for adjacent water
	self.hydrated = WaterSystem.instance.has_adjacent_water(self.world_coords)
	
