extends GridContainer

var inventory = preload("res://inventory/resources/inventory.tres")

func _ready():
	inventory.connect("items_changed", self, "on_items_changed")
	inventory.set_item(0, preload("res://inventory/resources/inv_item/ash.tres"))
	inventory.set_item(2, preload("res://inventory/resources/inv_item/ash.tres"))
	inventory.set_item(3, preload("res://inventory/resources/inv_item/stone.tres"))
	inventory.items[3].amount = 99
	inventory.items[4] = inventory.items[3].copy()
	update_inventory_display()

func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)

func on_items_changed(indices):
	for item_index in indices:
		update_inventory_slot_display(item_index)

func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)
