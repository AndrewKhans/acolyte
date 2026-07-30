class_name Block

var tileset_coords: Vector2i
var world_coords: Vector2i

func _init(_tileset_coords: Vector2i):
	self.tileset_coords = _tileset_coords

# Called on this block each tick
func on_tick(delta: float) -> void:
	pass

func primary_action():
	pass

func secondary_action():
	pass
