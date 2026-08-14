class_name WheatBlock extends Block

const TILESET_COORDS = Vector2i(3,0)

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)
	
func touched_player(player: CharacterBody2D) -> void:
	player.get_node("Inventory").add_itemStack_to_hotbar(Wheat.new(1))
	player.get_node("Inventory").add_itemStack_to_hotbar(Seeds.new(randi_range(1,2)))
	BlockSystem.instance.remove_block(self.world_coords)
