class_name Inventory extends Node

const HOTBAR_SIZE: int = 6

const ITEM_TYPE_TO_SLOT: Dictionary = {
	"Shovel":    0,
	"Seeds":     1,
	"Wheat":     2,
	"IronIngot": 3,
	"Generator": 4,
	"Producer":  5,
}

@export var HotbarSlotScene: PackedScene
@export var hotbar_ui: CenterContainer

var hotbar_items: Array[ItemStack] = []
var current_slot = 0

func _ready() -> void:
	create_hotbar_ui_slots()
	for i in range(HOTBAR_SIZE): hotbar_items.append(null)
	
	add_itemStack_to_hotbar(Shovel.new())
	add_itemStack_to_hotbar(Seeds.new(5))
	add_itemStack_to_hotbar(Wheat.new(20))
	add_itemStack_to_hotbar(IronIngot.new(15))
	add_itemStack_to_hotbar(Generator.new(5))
	add_itemStack_to_hotbar(Producer.new(5))
	
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
	
	var slot = ITEM_TYPE_TO_SLOT[item_type]
	
	if hotbar_items[slot] == null:
		hotbar_items[slot] = item
	else:
		hotbar_items[slot].count += item.count
	update_slot_icon(slot)
	
# Returns the player's count of the given item
func get_item_count(item_type) -> int:
	if hotbar_items[ITEM_TYPE_TO_SLOT[item_type]] == null: return 0
	return hotbar_items[ITEM_TYPE_TO_SLOT[item_type]].count

func remove_items(item_type, count) -> void:
	var slotNum = ITEM_TYPE_TO_SLOT[item_type]
	hotbar_items[slotNum].count -= count
	if hotbar_items[slotNum].count <= 0: hotbar_items[slotNum].count = 0
	update_slot_icon(slotNum)
	
func create_hotbar_ui_slots() -> void:
	for i in range(HOTBAR_SIZE):
		var slot = HotbarSlotScene.instantiate()

		slot.name = "Slot%d" % i
		#slot.position = Vector2(i * 64, 0)

		hotbar_ui.get_node("HBox").add_child(slot)

# Update the item icon and count in a slot
func update_slot_icon(slotNum) -> void:
	var hotbarSprite := hotbar_ui.get_node("HBox").get_node("Slot%d" % slotNum).get_node_or_null("ItemSprite")
	
	if hotbar_items[slotNum] == null or hotbar_items[slotNum].count == 0: # Slot should be empty
		if hotbarSprite != null: hotbarSprite.queue_free()
	elif hotbarSprite == null: # Slot is empty but should have a sprite (it was just added to hotbar)
		var itemSprite := Sprite2D.new()
		itemSprite.name = "ItemSprite"
		itemSprite.texture = hotbar_items[slotNum].item_texture
		hotbar_ui.get_node("HBox").get_node("Slot%d" % slotNum).add_child(itemSprite)
		
		var label := Label.new()
		label.name = "Count"
		label.text = "" if hotbar_items[slotNum].count < 2 else str(hotbar_items[slotNum].count)
		#var size := itemSprite.texture.get_size()
		itemSprite.add_child(label)
	else: # Update count
		var label := hotbar_ui.get_node("HBox").get_node("Slot%d" % slotNum).get_node("ItemSprite").get_node("Count")
		label.text = "" if hotbar_items[slotNum].count < 2 else str(hotbar_items[slotNum].count)
		
		
func primary_action_held_item(target_loc: Vector2) -> void:
	if hotbar_items[current_slot] == null: return
	hotbar_items[current_slot].primary_action(target_loc)
	if hotbar_items[current_slot].count == 0: hotbar_items[current_slot] = null
	update_slot_icon(current_slot)
	
func secondary_action_held_item(target_loc: Vector2) -> void:
	if hotbar_items[current_slot] == null: return
	hotbar_items[current_slot].secondary_action(target_loc)
	if hotbar_items[current_slot].count == 0: hotbar_items[current_slot] = null
	update_slot_icon(current_slot)
