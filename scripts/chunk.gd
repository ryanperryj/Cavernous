extends Node2D

export var seed_str = "spurples"

var noise = preload("res://scripts/noise.gd").Noise.new(seed_str)
var background_scene = preload("res://instances/Background.tscn")

enum {
	STONE, MOSS
}

var index: int
var cave_depth = 16
var tunnel_depth = 112

var world_depth = 128

func _ready(): 
	var width = get_node("..").chunk_width
	create_background(width, world_depth, STONE)
	for x in range(0, width):
		for y in range(0, world_depth):
			if y < cave_depth:
				# y = 0 to 15
				create_tile(x, y, STONE)
			elif y >= cave_depth and y < tunnel_depth:
				# y = 16 to 111
				if y < 32:
					# y = 16 to 31
					var cutoff = 1.033 - 0.033 * (y - 15)
					if noise.value_noise_2D((index*width + x) / 10.0, y / 10.0) < cutoff:
						create_tile(x, y, MOSS)
				elif y > 95:
					# y = 96 to 111
					var cutoff = 0.033 * (y - 80) - 0.033
					if noise.value_noise_2D((index*width + x) / 10.0, y / 10.0) < cutoff:
						create_tile(x, y, MOSS)
				else:
					if noise.value_noise_2D((index*width + x) / 10.0, y / 10.0) < 0.5:
						create_tile(x, y, STONE)
			elif y >= tunnel_depth:
				create_tile(x, y, STONE)

func create_tile(x, y, type):
	$TileMap.set_cell(x, y, type)

func create_background(width, height, type):
	var new_background = background_scene.instance()
	new_background.background_type = type
	new_background.width = width*16
	new_background.height = height*16
	add_child(new_background)
