extends Control

# How long it takes the text to change between black/red
const TEXT_ANIMATION_DURATION = 1

var generator: GeneratorBlock
var player: CharacterBody2D
var all_wheats: Array

# Animated text vars
var red = Color(0.616, 0.0, 0.0, 1.0)
var black = Color(0.0, 0.0, 0.0, 1.0)
var secondsSinceTextSwap = 0

func _init() -> void:
	for i in range(1, GeneratorBlock.MAX_WHEAT + 1):
		all_wheats.append("Wheat" + str(i))

func show_ui(HUD: Control, player: CharacterBody2D, generator: GeneratorBlock) -> void:
	self.generator = generator
	self.player = player
	
	secondsSinceTextSwap = 0
	$Background/Warning.set("theme_override_colors/font_color", black)
	if generator.hydrated:
		$Background/Warning.hide()
	else:
		$Background/Warning.show()
	
	for w in all_wheats: $Background/Wheats.get_node(w).hide()

	update_graphics()
	show()

func insert_wheat_to_generator() -> void:
	var space_in_generator = len(all_wheats) - generator.wheatCount
	var wheatCount = self.player.get_node("Inventory").get_item_count("Wheat")
	
	var wheatToAdd = space_in_generator if wheatCount >= space_in_generator else wheatCount
	if wheatToAdd <= 0: return
	self.player.get_node("Inventory").remove_items("Wheat", wheatToAdd)
	self.generator.wheatCount += wheatToAdd
	
	update_graphics()

func _process(delta: float) -> void:
	if self.visible:
		update_graphics()
	secondsSinceTextSwap += delta
	if secondsSinceTextSwap >= TEXT_ANIMATION_DURATION:
		if $Background/Warning.get("theme_override_colors/font_color") == black:
			$Background/Warning.set("theme_override_colors/font_color", red)
		else:
			$Background/Warning.set("theme_override_colors/font_color", black)
		secondsSinceTextSwap = 0

func update_graphics() -> void:
	update_wheats_display()
	update_button_display()
	
func update_wheats_display() -> void:
	var visibleWheats = []
	var hiddenWheats = []
	for w in all_wheats:
		if $Background/Wheats.get_node(w).visible:
			visibleWheats.append(w)
		else:
			hiddenWheats.append(w)
	
	var wheatDiff = self.generator.wheatCount - len(visibleWheats)
	if wheatDiff > 0: # Need to show more wheats
		for i in range(wheatDiff):
			var index := randi_range(0,len(hiddenWheats)-1)
			var w = hiddenWheats.pop_at(index)
			$Background/Wheats.get_node(w).show()
	elif wheatDiff < 0: # Need to hide more wheats
		wheatDiff *= -1
		for i in range(wheatDiff):
			var index := randi_range(0,len(visibleWheats)-1)
			var w = visibleWheats.pop_at(index)
			$Background/Wheats.get_node(w).hide()

func update_button_display() -> void:
	if self.generator.running:
		$Background.get_node("Button").texture_normal.set_current_frame(1)
	else:
		$Background.get_node("Button").texture_normal.set_current_frame(0)

func _on_button_pressed() -> void:
	insert_wheat_to_generator()
