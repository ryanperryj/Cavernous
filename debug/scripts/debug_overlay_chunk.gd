extends Node2D

var stats = []

func _ready():
	pass

func add_stat(name, object, ref, is_method, arg):
	stats.append([name, object, ref, is_method, arg])

func _process(delta):
	var label_text = ""
	
	for s in stats:
		var value = null
		if s[1] and weakref(s[1]).get_ref(): 
			if s[3]:
				value = s[1].call(s[2], s[4])
			else:
				value = s[1].get(s[2])
			label_text += str(s[0], ": ", value)
			label_text += "\n"
	
	$Label.text = label_text

func draw_chunk_border():
	$Sprite.visible = true
	$Sprite.scale = Vector2(Globals.sz_ch/4.0, Globals.sz_ch/4.0)
