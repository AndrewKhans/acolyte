extends Control

var crafter: CrafterBlock
var player: CharacterBody2D

const IRON_PER_PRODUCER := 2
const IRON_PER_GENERATOR := 4

func show_ui(HUD: Control, player: CharacterBody2D, crafter: CrafterBlock) -> void:
	self.crafter = crafter
	self.player = player
	
	$"Background/Producer Button/Label".text = str(IRON_PER_PRODUCER)
	$"Background/Generator Button/Label".text = str(IRON_PER_GENERATOR)
	show()

func _on_producer_button_pressed() -> void:
	$Sfx.play()
	var ironCount = player.get_node("Inventory").get_item_count("IronIngot")
	if ironCount >= IRON_PER_PRODUCER:
		player.get_node("Inventory").remove_items("IronIngot", IRON_PER_PRODUCER)
		player.get_node("Inventory").add_itemStack_to_hotbar(Producer.new(1))

func _on_generator_button_pressed() -> void:
	$Sfx.play()
	var ironCount = player.get_node("Inventory").get_item_count("IronIngot")
	if ironCount >= IRON_PER_GENERATOR:
		player.get_node("Inventory").remove_items("IronIngot", IRON_PER_GENERATOR)
		player.get_node("Inventory").add_itemStack_to_hotbar(Generator.new(1))
