extends CharacterBody2D

const SPEED = 100
const TILE_SIZE = 32
const BLOCK_BREAK_TIME = 1.5
const BLOCK_BREAK_ANIMATION_TOTAL_FRAMES = 13

@onready var tile_outline := $TileOutline
@export var HUD: Control

var targeted_block_coords
var in_interface: bool = false
var can_move: bool = false
var breaking_block: bool = false
var breaking_block_time := 0.0

func _ready():
	tile_outline.visible = false
	
func _process(_delta: float) -> void:
	if in_interface or not can_move: return
	block_break_logic(_delta)
	update_tile_outline()

func _physics_process(_delta: float) -> void:
	if in_interface or not can_move: return
	
	var block_loc := BlockSystem.world_coords_to_block_coords(self.global_position)
	var block = BlockSystem.instance.get_block_obj(block_loc)
	if block != null: block.touched_player(self)
	handle_movement()

func _input(event):
	if in_interface:
		if Input.is_action_pressed("move_right") \
		or Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_up") \
		or Input.is_action_pressed("move_down") \
		or Input.is_action_pressed("escape"):
			HUD.hide_interfaces()
			in_interface = false
		return
		
	var mouse_pos = get_global_mouse_position()
	
	if event.is_action_pressed("primary_action"):
		# If they hold left click, break the target block
		# If there is no targeted block, call the left click action of their item
		$Inventory.primary_action_held_item(mouse_pos)
		breaking_block = true
	if event.is_action_pressed("secondary_action"):
		# If they click on an interactable block, interact with it
		var target_block := BlockSystem.world_coords_to_block_coords(mouse_pos)
		var block := BlockSystem.instance.get_block_obj(target_block)
		if block != null:
			in_interface = block.secondary_action(self, HUD)
		else:
			# Else, call the right click action of their item
			$Inventory.secondary_action_held_item(mouse_pos)
	
	if event.is_action_released("primary_action"):
		breaking_block = false

func handle_movement():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"): velocity.x += 1
	if Input.is_action_pressed("move_left"):  velocity.x -= 1
	if Input.is_action_pressed("move_down"):  velocity.y += 1
	if Input.is_action_pressed("move_up"):    velocity.y -= 1

	velocity = velocity.normalized() * SPEED

	if velocity.length() > 10:
		$AnimatedSprite2D.rotation = velocity.angle()

	move_and_slide()

func update_tile_outline():
	var mouse_pos = get_global_mouse_position()
	
	# Snap mouse position to grid
	var tile_pos = Vector2(
		floor(mouse_pos.x / TILE_SIZE),
		floor(mouse_pos.y / TILE_SIZE)
	)

	# Convert back to world coordinates (center of tile)
	var snapped_pos = tile_pos * TILE_SIZE + Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

	tile_outline.global_position = snapped_pos
	tile_outline.visible = true
	
	targeted_block_coords = tile_pos

func block_break_logic(_delta) -> void:
	if not breaking_block:
		breaking_block_time = 0.0
		$TileOutline.play("default")
		return
	
	if targeted_block_coords == null: return
	var block = BlockSystem.instance.get_block_obj(targeted_block_coords)
	if block == null or (block.get_script().get_global_name() != "GeneratorBlock" and block.get_script().get_global_name() != "ProducerBlock" and block.get_script().get_global_name() != "SeedsBlock"):
		breaking_block = false
		return
	
	# We can actually start breaking this block
	var animation_speed = BLOCK_BREAK_ANIMATION_TOTAL_FRAMES/BLOCK_BREAK_TIME
	$TileOutline.play("breaking", animation_speed)
	breaking_block_time += _delta
	if breaking_block_time >= BLOCK_BREAK_TIME:
		breaking_block = false
		if block.get_script().get_global_name() == "GeneratorBlock":
			$Inventory.add_itemStack_to_hotbar(Generator.new(1))
		elif block.get_script().get_global_name() == "ProducerBlock":
			$Inventory.add_itemStack_to_hotbar(Producer.new(1))
		elif block.get_script().get_global_name() == "SeedsBlock":
			$Inventory.add_itemStack_to_hotbar(Seeds.new(1))
		BlockSystem.instance.remove_block(targeted_block_coords)
