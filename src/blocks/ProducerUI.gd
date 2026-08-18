extends Control

const TEXT_ANIMATION_DURATION = 1
const PROGRESS_BAR_FRAME_COUNT := 24

var producer: ProducerBlock
var player: CharacterBody2D

var all_items: Array

# Animated text vars
var red = Color(0.616, 0.0, 0.0, 1.0)
var black = Color(0.0, 0.0, 0.0, 1.0)
var secondsSinceTextSwap = 0

func _init() -> void:
	for i in range(1, ProducerBlock.MAX_IRON + 1):
		all_items.append("Item" + str(i))

func show_ui(HUD: Control, player: CharacterBody2D, producer: ProducerBlock) -> void:
	self.producer = producer
	self.player = player
	
	show()

func _process(delta: float) -> void:
	if not self.visible: return
	update_graphics(delta)

func update_graphics(delta: float) -> void:
	update_warning_text(delta)
	update_item_displayed()
	update_progress_bar()

func update_warning_text(delta: float) -> void:
	if producer.hasArtifact:
		$Background/Warning.text = "Waiting For Midnight"
	elif producer.powered and producer.hydrated:
		$Background/Warning.text = ""
	else:
		$Background/Warning.text = ""
		if not producer.hydrated:
			$Background/Warning.text = "Needs Adjacent Water\n"
		if not producer.powered:
			$Background/Warning.text += "Needs Power"
	
	# Flashing text
	if producer.hasArtifact:
		$Background/Warning.set("theme_override_colors/font_color", black)
	else:
		secondsSinceTextSwap += delta
		if secondsSinceTextSwap >= TEXT_ANIMATION_DURATION:
			if $Background/Warning.get("theme_override_colors/font_color") == black:
				$Background/Warning.set("theme_override_colors/font_color", red)
			else:
				$Background/Warning.set("theme_override_colors/font_color", black)
			secondsSinceTextSwap = 0

func update_item_displayed() -> void:
	if self.producer.hasArtifact:
		$Background/Artifact.show()
		$Background/IronIngot.hide()
		$Background/Button.texture_normal.set_current_frame(1)
		return
	else:
		$Background/Button.texture_normal.set_current_frame(0)
		
	if $Background/Button.is_hovered() and self.producer.hasIron:
		$Background/IronIngot.show()
		$Background/Artifact.hide()
	else:
		$Background/Artifact.hide()
		$Background/IronIngot.hide()

func update_progress_bar() -> void:
	#if not producer.running:
		#$Background/ProgressBar.hide()
		#return
	
	
	var percentProgress = float(producer.processingCompleted) / producer.PROCESS_TIME_TICKS
	
	$Background/ProgressBar.frame = floor(percentProgress * PROGRESS_BAR_FRAME_COUNT)
	$Background/ProgressBar.show()

func _on_button_pressed() -> void:
	var playerIronCount = player.get_node("Inventory").get_item_count("IronIngot")
	if playerIronCount > 0 and not producer.hasIron and not producer.hasArtifact:
		player.get_node("Inventory").remove_items("IronIngot", 1)
		producer.hasIron = true
		$Sfx.play()
