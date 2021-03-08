extends CenterContainer

var inventory = preload("res://inventory/resources/inventory.tres")

func display_item(item):
	if item is Inv_Item:
		$ItemTextureRect.texture = item.texture
		if item.amount == 1:
			$SlotTextureRect/AmountLabel.text = ""
		else:
			$SlotTextureRect/AmountLabel.text = str(item.amount)
	else:
		$ItemTextureRect.texture = null
		$SlotTextureRect/AmountLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.set_item(item_index, null)
	if item is Inv_Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		
		inventory.drag_data = data
		
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	
	if my_item is Inv_Item and my_item.name == data.item.name:
		my_item.amount += data.item.amount
		inventory.emit_signal("items_changed", [my_item_index])
	else:
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
	
	inventory.drag_data = null
