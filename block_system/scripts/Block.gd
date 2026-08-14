class_name Block

var tileset_coords: Vector2i
var world_coords: Vector2i

func _init(_tileset_coords: Vector2i, _world_coords: Vector2i):
	self.tileset_coords = _tileset_coords
	self.world_coords = _world_coords
	self.update()

# Called on this block each tick
func on_tick() -> void:
	pass

func primary_action():
	pass

# Returns true if the user is now in an interface
@warning_ignore("unused_parameter")
func secondary_action(player: CharacterBody2D, HUD: Control) -> bool:
	return false

# Called if the block touches the player
func touched_player(player: CharacterBody2D) -> void:
	pass
	
# Like a block-update from Minecraft
func update() -> void:
	pass
	
