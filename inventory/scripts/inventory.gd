extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indices)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null,
]

func set_item(item_index, item):
	var previousItem = items[item_index]
	if item is Inv_Item:
		items[item_index] = item.copy()
	else:
		items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

func swap_items(item_index_1, item_index_2):
	var item_1 = items[item_index_1]
	var item_2 = set_item(item_index_2, item_1)
	set_item(item_index_1, item_2)
