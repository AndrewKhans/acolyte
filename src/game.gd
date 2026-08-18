extends Node

@export var MovingArtifact: PackedScene

const ROTATE_0   = 0
const ROTATE_90  = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H
const TICK_RATE := 60 # ticks per second
const MAX_ARTIFACT_COUNT = 8

var secondsSinceLastTick := 0
var ironSpawnLocations: Array
var artifactCount := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Audio/Ambient1.play()
	update_artifact_display()
	
	ironSpawnLocations = BlockSystem.instance.get_used_cells_by_id(0, Vector2i(2, 1))
	for coords in ironSpawnLocations:
		BlockSystem.instance.set_cell(coords, -1)
	spawn_random_iron()
	
	var crafterLocations = BlockSystem.instance.get_used_cells_by_id(0, Vector2i(1,0))
	for coords in crafterLocations:
		BlockSystem.instance.set_cell(coords, -1)
		BlockSystem.instance.add_block(CrafterBlock.new(coords))
	
	$Player/CanvasLayer/IntroFadeIn.show()
	var tween := create_tween()
	tween.set_parallel(false)
	tween.tween_property($Player/CanvasLayer/IntroFadeIn, "modulate:a", 0.0, 3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await get_tree().create_timer(2).timeout

	$Player.can_move = true
	
	#await get_tree().create_timer(10).timeout
	#outro()

func _process(delta: float) -> void:
	secondsSinceLastTick += delta
	if secondsSinceLastTick >= 1/TICK_RATE:
		
		BlockSystem.instance.tick_blocks()
		
		secondsSinceLastTick = 0

func spawn_random_iron() -> void:
	var ingotsToSpawn = randi_range(7, 10)
	var locs = []
	for l in ironSpawnLocations: locs.append(l)
	locs.shuffle()
	for i in range(randi_range(5,8)):
		var l = locs.pop_back()
		var rot = ROTATE_0 if randi_range(0,1) else ROTATE_90
		BlockSystem.instance.add_block(IronIngotBlock.new(l))
		
		BlockSystem.instance.set_cell(l, 0, IronIngotBlock.TILESET_COORDS, rot)

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
	#spawn_random_iron()
	pass

func _on_day_night_system_midnight() -> void:
	guy_harvests_artifacts()
	await get_tree().create_timer(10).timeout
	spawn_random_iron()

func _on_artifact_harvested() -> void:
	artifactCount += 1
	if artifactCount >= MAX_ARTIFACT_COUNT:
		artifactCount = MAX_ARTIFACT_COUNT
		outro()
	
	update_artifact_display()
	
func update_artifact_display() -> void:
	var text = "%d/%d" % [artifactCount, MAX_ARTIFACT_COUNT]
	$Player/CanvasLayer/HUD/ArtifactCounter/Label.text = text

func flash_artifact_display() -> void:
	for i in range(5):
		$Player/CanvasLayer/HUD/ArtifactCounter/Label.hide()
		await get_tree().create_timer(0.15).timeout
		$Player/CanvasLayer/HUD/ArtifactCounter/Label.show()
		await get_tree().create_timer(0.3).timeout

func outro() -> void:
	var musicTween := create_tween()
	musicTween.set_ease(Tween.EASE_IN_OUT)
	musicTween.tween_property(
		$Audio/Ambient1,
		"volume_db",
		-10.0,
		5.0
	)
	update_artifact_display()
	flash_artifact_display()
	await get_tree().create_timer(1).timeout
	$Audio/Outro.play()
	$Player.can_move = false
	$Player/CanvasLayer/HUD.hide_interfaces()
	
	var tween := create_tween()
	tween.tween_property($Player/CanvasLayer/HUD/HotbarUI, "modulate:a", 0.0, 1)
	tween.set_parallel(false)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		$Player/Camera2D,
		"global_position",
		$Entities/BigGuy.global_position,
		5.0
	)
	$Audio/Ambient1.stop()

	tween.tween_property($Entities/BigGuy/Asleep, "modulate:a", 0.0, 3)
	await tween.finished
	
	$Entities/BigGuy.hover_speed(0.4, 0.8)
	$Entities/BigGuy.hover()
	await get_tree().create_timer(1).timeout
	var rotateTween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	rotateTween.tween_property($Entities/BigGuy, "rotation", deg_to_rad(0), 3)
	await rotateTween.finished
	
	await get_tree().create_timer(3).timeout
	
	var playerPos = $Entities/BigGuy.global_position
	playerPos.x += 80
	var playerMoveTween := create_tween()
	playerMoveTween.set_parallel(false)
	playerMoveTween.set_ease(Tween.EASE_IN_OUT)
	playerMoveTween.tween_property(
		$Player/AnimatedSprite2D,
		"global_position",
		playerPos,
		2.0
	)
	await playerMoveTween.finished
	hover($Player/AnimatedSprite2D, 7)
	await get_tree().create_timer(3).timeout
	
	big_guy_shake()
	
	await get_tree().create_timer(9).timeout
	var fadeTween := create_tween()
	fadeTween.tween_property($Player/CanvasLayer/IntroFadeIn, "modulate:a", 1.0, 6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func hover(target, totalDuration) -> void:
	var hover_distance := 2.0
	var hover_time_min := 0.4
	var hover_time_max := 0.8
	var big_guy = target
	var big_guy_start_pos = target.position
	
	while totalDuration > 0:
		# Pick a random nearby position
		var random_offset := Vector2(
			randf_range(-hover_distance, hover_distance),
			randf_range(-hover_distance, hover_distance)
		)

		var target_pos = big_guy_start_pos + random_offset
		var duration = randf_range(hover_time_min, hover_time_max)

		var tween := create_tween()
		tween.tween_property(
			big_guy,
			"position",
			target_pos,
			duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		totalDuration -= duration
		await tween.finished

func big_guy_shake() -> void:
	var delay = 1
	$Entities/BigGuy.hover_speed(0.2, 0.4)
	await get_tree().create_timer(delay).timeout
	$Entities/BigGuy.hover_speed(0.1, 0.2)
	await get_tree().create_timer(delay).timeout
	$Entities/BigGuy.hover_speed(0.05, 0.1)
	await get_tree().create_timer(delay).timeout
	$Entities/BigGuy.hover_speed(0.02, 0.05)
	await get_tree().create_timer(delay).timeout
	$Entities/BigGuy.hover_speed(0.01, 0.02)
	await get_tree().create_timer(delay*3).timeout
	
	
	var eatTween := create_tween()
	eatTween.set_parallel(true)
	eatTween.tween_property(
		$Player/AnimatedSprite2D,
		"global_position",
		$Entities/BigGuy.global_position,
		0.1
	)
	await eatTween.finished
	$Audio/GuyEat.play()
	
	$Entities/BigGuy.hover_speed(0.4, 0.8)
	
