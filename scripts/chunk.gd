extends Node2D

export var seed_str = "spurples"

var noise = preload("res://scripts/noise.gd").Noise.new(seed_str)
var background_scene = preload("res://instances/Background.tscn")

var AIR = -1

enum {
	STONE, MOSS,
}

enum {
	STONE_BG,
}

var pos_ch: Vector2
var sz_ch: int
var cave_depth = 16
var tunnel_depth = 112
var world_depth = 128

var tl_types = []

func _ready(): 
	sz_ch = get_node("..").sz_ch
	
	# draw chunk border
	$Ch_Border_Sprite.scale = Vector2(sz_ch, sz_ch)
	
	# init tile_data array
	var c = 0 ; var r = 0
	while c < sz_ch:
		tl_types.append([])
		r = 0
		while r < sz_ch:
			tl_types[c].append(-1)
			r += 1
		c += 1
	
	create_background(sz_ch, sz_ch, STONE_BG)
	for x in range(sz_ch):
		for y in range(sz_ch):
			var x_global = pos_ch.x*sz_ch + x
			var y_global = pos_ch.y*sz_ch + y
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
	tl_types[y][x] = type

func create_background(width, height, type):
	var new_background = background_scene.instance()
	new_background.background_type = type
	new_background.width = width*16
	new_background.height = height*16
	add_child(new_background)
