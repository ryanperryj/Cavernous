extends Resource
class_name Inv_Item

export(String)  var name = ""
export(Texture) var texture

var amount = 1

func copy():
	var item_copy = self.duplicate()
	item_copy.amount = self.amount
	return item_copy
