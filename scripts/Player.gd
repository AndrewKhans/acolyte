extends CharacterBody2D

const SPEED = 100
const TILE_SIZE = 32

@onready var tile_outline := $TileOutline # Sprite2D child node

func _ready():
	tile_outline.visible = false
	
func _process(_delta: float) -> void:
	update_tile_outline()

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"): velocity.x += 1
	if Input.is_action_pressed("move_left"):  velocity.x -= 1
	if Input.is_action_pressed("move_down"):  velocity.y += 1
	if Input.is_action_pressed("move_up"):    velocity.y -= 1

	velocity = velocity.normalized() * SPEED

	if velocity.length() > 10:
		$AnimatedSprite2D.rotation = velocity.angle()

	move_and_slide()

func _input(event):
	var targeted_square = update_tile_outline()
	if event.is_action_pressed("primary_action"):
		# If they hold left click, break the target block
		# If there is no targeted block, call the left click action of their item
		$Inventory.primary_action_held_item()
	if event.is_action_pressed("secondary_action"):
		# If they click on an interactable block, interact with it
		print_debug(targeted_square)
		# Else, call the right click action of their item
		$Inventory.secondary_action_held_item(targeted_square)

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
	
	return tile_pos
