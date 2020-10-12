extends WorldEnvironment

var chunk = preload("res://instances/chunk.tscn")

var chunk_width: int = 1
export var load_distance: int = 64
var current_chunk: int
var loaded_chunks = {}

func _ready():
	pass

func _process(delta):
	# === Chunk Loading === #
	current_chunk = floor($loader.position.x / (chunk_width*16.0))
	for i in range(current_chunk - load_distance, current_chunk + load_distance + 1):
		if !loaded_chunks.has(i):
			loaded_chunks[i] = chunk.instance()
			loaded_chunks[i].index = i
			loaded_chunks[i].translate(Vector2(i*chunk_width*16, 0))
			add_child(loaded_chunks[i])
			#print("current " + str(current_chunk))
			#print("loaded " + str(i))
	
	var i_left_chunk = current_chunk - load_distance - 1
	if loaded_chunks.has(i_left_chunk):
		loaded_chunks[i_left_chunk].queue_free()
		loaded_chunks.erase(i_left_chunk)
		#print("removed " + str(i_left_chunk))
	
	var i_right_chunk = current_chunk + load_distance + 1
	if loaded_chunks.has(i_right_chunk):
		loaded_chunks[i_right_chunk].queue_free()
		loaded_chunks.erase(i_right_chunk)
		#print("removed " + str(i_right_chunk))
	# ===================== #
	

func _input(event):
	if event.is_action_released("quit"):
		get_tree().quit()
	if event.is_action_released("reload"):
		get_tree().reload_current_scene()
