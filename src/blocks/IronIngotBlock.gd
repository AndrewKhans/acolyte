class_name IronIngotBlock extends Block

const TILESET_COORDS = Vector2i(2,1)

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)
	
func touched_player(player: CharacterBody2D) -> void:
	player.get_node("Inventory").add_itemStack_to_hotbar(IronIngot.new(1))
	BlockSystem.instance.remove_block(self.world_coords)
