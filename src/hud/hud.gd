extends Control

func show_generator_ui(player: CharacterBody2D, generator: GeneratorBlock) -> void:
	get_node("GeneratorUI").show_ui(self, player, generator)

func show_producer_ui(player: CharacterBody2D, producer: ProducerBlock) -> void:
	get_node("ProducerUI").show_ui(self, player, producer)

func show_crafter_ui(player: CharacterBody2D, crafter: CrafterBlock) -> void:
	get_node("CrafterUI").show_ui(self, player, crafter)


func hide_interfaces() -> void:
	$GeneratorUI.hide()
	$ProducerUI.hide()
	$CrafterUI.hide()
