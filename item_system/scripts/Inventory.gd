class_name Inventory extends Node

const HOTBAR_SIZE: int = 6

@export var HotbarSlotScene: PackedScene
@export var hotbar_ui: CenterContainer

var hotbar_items: Array[ItemStack] = []
var current_slot = 0

func _ready() -> void:
	create_hotbar_ui_slots()
	for i in range(HOTBAR_SIZE): hotbar_items.append(null)
	
	add_itemStack_to_hotbar(Shovel.new(1))
	add_itemStack_to_hotbar(Seeds.new(5))
	
	hotbar_ui.get_node("HBox").get_node("Slot0").get_node("HotbarSprite").play("selected")

func _process(_delta: float) -> void:
	var previous_slot = current_slot
	
	if Input.is_action_just_pressed("hotkey_1"):   current_slot = 0
	elif Input.is_action_just_pressed("hotkey_2"): current_slot = 1
	elif Input.is_action_just_pressed("hotkey_3"): current_slot = 2
	elif Input.is_action_just_pressed("hotkey_4"): current_slot = 3
	elif Input.is_action_just_pressed("hotkey_5"): current_slot = 4
	elif Input.is_action_just_pressed("hotkey_6"): current_slot = 5
		
	if Input.is_action_just_pressed("hotbar_scroll_up"):
		current_slot += 1
		if current_slot >= HOTBAR_SIZE: current_slot = 0 
	elif Input.is_action_just_pressed("hotbar_scroll_down"):
		current_slot -= 1
		if current_slot < 0: current_slot = HOTBAR_SIZE-1 
	
	if current_slot != previous_slot:
		hotbar_ui.get_node("HBox").get_node("Slot%d" % current_slot).get_node("HotbarSprite").play("selected")
		hotbar_ui.get_node("HBox").get_node("Slot%d" % previous_slot).get_node("HotbarSprite").play("unselected")
		
func add_itemStack_to_hotbar(item: ItemStack):
	var item_type = item.get_script().get_global_name()
	
	var slot
	if item_type == "Shovel": slot = 0
	if item_type == "Seeds":  slot = 1
	
	hotbar_items[slot] = item
	update_slot_icon(slot)
	

#func add_itemStack_to_hotbar(item: ItemStack) -> bool:
	## Try to stack with existing items
	#for stack in hotbar_items:
		#if stack.item.get_script() == item.get_script():
			#stack.count += item.count
			#return true
#
	## Otherwise create a new stack
	#if hotbar_items.size() < HOTBAR_SIZE:
		#hotbar_items.append(item)
		#return true
#
	## Inventory full
	#return false

func create_hotbar_ui_slots() -> void:
	for i in range(HOTBAR_SIZE):
		var slot = HotbarSlotScene.instantiate()

		slot.name = "Slot%d" % i
		#slot.position = Vector2(i * 64, 0)

		hotbar_ui.get_node("HBox").add_child(slot)

# Update the item icon and count in a slot
func update_slot_icon(slotNum) -> void:
	if hotbar_items[slotNum] == null:
		hotbar_ui.get_node("HBox").get_node("Slot%d" % slotNum).get_node("HotbarSprite").play("selected")
	else:
		var itemSprite := Sprite2D.new()
		itemSprite.texture = hotbar_items[slotNum].item_texture
		hotbar_ui.get_node("HBox").get_node("Slot%d" % slotNum).add_child(itemSprite)

func primary_action_held_item() -> void:
	hotbar_items[current_slot].primary_action()
	
func secondary_action_held_item() -> void:
	hotbar_items[current_slot].secondary_action()
