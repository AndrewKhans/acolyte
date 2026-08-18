class_name WheatBlock extends Block

const TILESET_COORDS = Vector2i(3,0)

func _init(worldCoords: Vector2i):
	super(TILESET_COORDS, worldCoords)
	
func touched_player(player: CharacterBody2D) -> void:
	player.get_node("Inventory").add_itemStack_to_hotbar(Wheat.new(1))
	var numseeds = 1 if randi_range(1,5) < 4 else 2
	player.get_node("Inventory").add_itemStack_to_hotbar(Seeds.new(numseeds))
	BlockSystem.instance.remove_block(self.world_coords)
	AudioSystem.instance.wheat()
