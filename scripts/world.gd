extends Node2D

var chunk = preload("res://instances/Chunk.tscn")

var chunk_size: int = 16
export var load_distance: int = 4
var ij_current_chunk: Vector2
var loaded_chunks = {}

func _ready():
	pass

func _process(delta):
	ij_current_chunk = ($Player.position / (chunk_size*16.0)).floor()
	# chunk loading
	var t_start: float = OS.get_ticks_msec()
	for i_relative in range(-load_distance, load_distance + 1):
		for j_relative in range(-load_distance, load_distance + 1):
			var ij = ij_current_chunk + Vector2(i_relative, j_relative)
			if !loaded_chunks.has(ij):
				loaded_chunks[ij] = chunk.instance()
				loaded_chunks[ij].chunk_index = ij
				loaded_chunks[ij].translate(ij*chunk_size*16)
				call_deferred("add_child", (loaded_chunks[ij]))
	print("chunk loading took: ", OS.get_ticks_msec() - t_start)
	
	# chunk unloading
	t_start = OS.get_ticks_msec()
	# top chunks
	for i_relative in range(-load_distance - 1, load_distance + 1):			#     x x x x o
		var ij = ij_current_chunk + Vector2(i_relative, -load_distance - 1)	#     o [   ] o
		if loaded_chunks.has(ij):											#     o [   ] o
			var chunk = loaded_chunks[ij]									#     o [   ] o
			chunk.queue_free()												#     o o o o o
			loaded_chunks.erase(ij)
	# bottom chunks
	for i_relative in range(-load_distance, load_distance + 2):				#     o o o o o
		var ij = ij_current_chunk + Vector2(i_relative, load_distance + 1)	#     o [   ] o
		if loaded_chunks.has(ij):											#     o [   ] o
			var chunk = loaded_chunks[ij]									#     o [   ] o
			chunk.queue_free()												#     o x x x x
			loaded_chunks.erase(ij)
	# right chunks
	for j_relative in range(-load_distance - 1, load_distance + 1):			#     o o o o x
		var ij = ij_current_chunk + Vector2(load_distance + 1, j_relative)	#     o [   ] x
		if loaded_chunks.has(ij):											#     o [   ] x
			var chunk = loaded_chunks[ij]									#     o [   ] o
			chunk.queue_free()												#     o o o o o
			loaded_chunks.erase(ij)
	# left chunks
	for j_relative in range(-load_distance , load_distance + 2):			#     o o o o o
		var ij = ij_current_chunk + Vector2(-load_distance - 1, j_relative)	#     x [   ] o
		if loaded_chunks.has(ij):											#     x [   ] o
			var chunk = loaded_chunks[ij]									#     o [   ] o
			chunk.queue_free()												#     x o o o o
			loaded_chunks.erase(ij)
	print("chunk unloading took: ", OS.get_ticks_msec() - t_start)

func _input(event):
	if event.is_action_released("quit"):
		get_tree().quit()
	if event.is_action_released("reload"):
		get_tree().reload_current_scene()
