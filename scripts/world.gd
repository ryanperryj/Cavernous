extends WorldEnvironment

var chunk = preload("res://instances/chunk.tscn")
var world_seed = 0

func _ready():
	randomize()
	world_seed = randi()
	
	var new_chunk = chunk.instance()
	add_child(new_chunk)
	new_chunk = chunk.instance()
	new_chunk.translate(Vector2(-512, 0))
	add_child(new_chunk)
	new_chunk = chunk.instance()
	new_chunk.translate(Vector2(512, 0))
	add_child(new_chunk)

func _input(event):
	if event.is_action_released("quit"):
		get_tree().quit()
	if event.is_action_released("reload"):
		get_tree().reload_current_scene()
