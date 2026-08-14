extends Node

#3da
const ROTATE_90  = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H
const TICK_RATE := 60 # ticks per second
@export var MovingArtifact: PackedScene

var secondsSinceLastTick := 0
var ironSpawnLocations: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ironSpawnLocations = BlockSystem.instance.get_used_cells_by_id(0, Vector2i(2, 1))
	for coords in ironSpawnLocations:
		BlockSystem.instance.set_cell(coords, -1)
	spawn_random_iron()
	
	
	var crafterLocations = BlockSystem.instance.get_used_cells_by_id(0, Vector2i(1,0))
	for coords in crafterLocations:
		BlockSystem.instance.set_cell(coords, -1)
		BlockSystem.instance.add_block(CrafterBlock.new(coords))
	

func _process(delta: float) -> void:
	secondsSinceLastTick += delta
	if secondsSinceLastTick >= 1/TICK_RATE:
		
		BlockSystem.instance.tick_blocks()
		
		secondsSinceLastTick = 0

func spawn_random_iron() -> void:
	var ingotsToSpawn = randi_range(5, 8)
	var locs = []
	for l in ironSpawnLocations: locs.append(l)
	locs.shuffle()
	for i in range(randi_range(5,8)):
		var l = locs.pop_back()
		
		BlockSystem.instance.add_block(IronIngotBlock.new(l))

func guy_harvests_artifacts() -> void:
	for coords in BlockSystem.instance.coords_to_block.keys():
		var block = BlockSystem.instance.coords_to_block[coords]
		if block.get_script().get_global_name() == "ProducerBlock":
			if block.hasArtifact:
				block.hasArtifact = false
				var movingArtifact = MovingArtifact.instantiate()
				movingArtifact.position = BlockSystem.block_coords_to_world_coords(coords)
				movingArtifact.harvested.connect(_on_artifact_harvested)
				add_child(movingArtifact)

func _on_day_night_system_cycle_completed() -> void:
	spawn_random_iron()

func _on_day_night_system_midnight() -> void:
	guy_harvests_artifacts()

func _on_artifact_harvested() -> void:
	print_debug("harvested")
