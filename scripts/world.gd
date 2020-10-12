extends Node2D

var chunk = preload("res://instances/chunk.tscn")

var chunk_width: int = 4
export var load_distance: int = 12
var i_current_chunk: int
var loaded_chunks = {}

var load_chunks_thread = Thread.new()
var unload_chunks_thread = Thread.new()
var mutex = Mutex.new()

func _ready():
	load_chunks_thread.start(self, "load_chunks_method", true)
	unload_chunks_thread.start(self, "unload_chunks_method", true)

func _process(delta):
	mutex.lock()
	i_current_chunk = floor($player.position.x / (chunk_width*16.0))
	mutex.unlock()

func load_chunks_method(thread_running):
	while thread_running:
		var i = i_current_chunk
		if !loaded_chunks.has(i):
			loaded_chunks[i] = chunk.instance()
			loaded_chunks[i].index = i
			loaded_chunks[i].translate(Vector2(i*chunk_width*16, 0))
			call_deferred("add_child", (loaded_chunks[i]))
		for i_relative in range(1, load_distance + 1):
			i = i_current_chunk + i_relative
			if !loaded_chunks.has(i):
				loaded_chunks[i] = chunk.instance()
				loaded_chunks[i].index = i
				loaded_chunks[i].translate(Vector2(i*chunk_width*16, 0))
				call_deferred("add_child", (loaded_chunks[i]))
				
			i = i_current_chunk - i_relative
			if !loaded_chunks.has(i):
				loaded_chunks[i] = chunk.instance()
				loaded_chunks[i].index = i
				loaded_chunks[i].translate(Vector2(i*chunk_width*16, 0))
				call_deferred("add_child", (loaded_chunks[i]))

func unload_chunks_method(thread_running):
	while thread_running:
		var i_left_chunk = i_current_chunk - load_distance - 1
		if loaded_chunks.has(i_left_chunk):
			loaded_chunks[i_left_chunk].queue_free()
			loaded_chunks.erase(i_left_chunk)
		
		var i_right_chunk = i_current_chunk + load_distance + 1
		if loaded_chunks.has(i_right_chunk):
			loaded_chunks[i_right_chunk].queue_free()
			loaded_chunks.erase(i_right_chunk)

func _input(event):
	if event.is_action_released("quit"):
		get_tree().quit()
	if event.is_action_released("reload"):
		get_tree().reload_current_scene()
