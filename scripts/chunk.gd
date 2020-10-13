extends Node2D

export var seed_str = "spurples"

var noise = preload("res://scripts/noise.gd").Noise.new(seed_str)
var background_scene = preload("res://instances/Background.tscn")

enum {
	STONE, MOSS
}

var chunk_index: Vector2
var cave_depth = 16
var tunnel_depth = 112

var world_depth = 128

func _ready(): 
	var chunk_size = get_node("..").chunk_size
	create_background(chunk_size, chunk_size, STONE)
	for x in range(0, chunk_size):
		for y in range(0, chunk_size):
			var x_global = chunk_index.x*chunk_size + x
			var y_global = chunk_index.y*chunk_size + y
			# top layer of solid stone
			if y_global < cave_depth:
				# y = 0 to 15
				create_tile(x, y, STONE)
			# cave layer
			elif y_global >= cave_depth and y_global < tunnel_depth:
				# y = 16 to 111
				if y_global < 32:
					# y = 16 to 31
					var cutoff = 1.033 - 0.033 * (y_global - 15)
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) < cutoff:
						create_tile(x, y, MOSS)
				elif y_global > 95:
					# y = 96 to 111
					var cutoff = 0.033 * (y_global - 80) - 0.033
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) < cutoff:
						create_tile(x, y, MOSS)
				else:
					var cutoff = 0.5
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) < cutoff:
						create_tile(x, y, STONE)
			# bottom layer of solid stone
			elif y_global >= tunnel_depth and y_global < world_depth:
				create_tile(x, y, STONE)

func create_tile(x, y, type):
	$TileMap.set_cell(x, y, type)

func create_background(width, height, type):
	var new_background = background_scene.instance()
	new_background.background_type = type
	new_background.width = width*16
	new_background.height = height*16
	add_child(new_background)
