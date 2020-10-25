extends Node2D

var noise_scr = preload("res://scripts/noise.gd")
var background_scn = preload("res://instances/Background.tscn")

var AIR = -1

enum {
	DIRT, STONE_DIRTY, STONE, STONE_DARK, STONE_LIGHT, 
	STONE_DIRTY_BRICK, STONE_BRICK, STONE_DARK_BRICK, STONE_LIGHT_BRICK, 
	ROOT,
}

enum {
	DIRT_BG, STONE_DIRTY_BG, STONE_BG, STONE_DARK_BG, STONE_LIGHT_BG, 
}

var ch_index: Vector2
var sz_ch: int
var cave_depth = 16
var tunnel_depth = 112
var world_depth = 128

var tl_types = []

func load_from_mem(sz_ch, tl_types_from_mem):
	var x = 0
	var y = 0
	while x < sz_ch:
		tl_types.append([])
		y = 0
		while y < sz_ch:
			tl_types[x].append(AIR)
			create_tile(x, y, tl_types_from_mem[x][y])
			y += 1
		x += 1


func generate(sz_ch):
	var noise = noise_scr.Noise.new(Globals.world_seed_str)
	# generate solid ground
	var x = 0
	var y = 0
	while x < sz_ch:
		tl_types.append([])
		y = 0
		while y < sz_ch:
			tl_types[x].append(AIR)
			var x_global = ch_index.x*sz_ch + x
			var y_global = ch_index.y*sz_ch + y
			# top layer of solid stone
			if  y_global < cave_depth - 3:
				# y = 0 to 12
				create_background(sz_ch, sz_ch, DIRT_BG)
				create_tile(x, y, DIRT)
			elif  y_global < cave_depth:
				# y = 13 to 15
				create_background(sz_ch, sz_ch, DIRT_BG)
				if noise.value_noise_1D(x_global / 10.0) > lerp(.5, 1, (y_global - 13)/(15 - 13)):
					create_tile(x, y, DIRT)
				else:
					create_tile(x, y, STONE_DIRTY)
			else:
				# y = 16 to 127
				if y_global < 29:
					# y = 16 to 28
					create_background(sz_ch, sz_ch, STONE_DIRTY_BG)
					create_tile(x, y, STONE_DIRTY)
				elif  y_global < 32:
					# y = 29 to 31
					create_background(sz_ch, sz_ch, STONE_DIRTY_BG)
					if noise.value_noise_1D(x_global / 10.0) > lerp(.5, 1, (y_global - 29)/(31 - 29)) - .1:
						create_tile(x, y, STONE_DIRTY)
					else:
						create_tile(x, y, STONE)
				elif y_global < 93:
					# y = 32 to 92
					create_background(sz_ch, sz_ch, STONE_BG)
					create_tile(x, y, STONE)
				elif y_global < 96:
					# y = 93 to 95
					create_background(sz_ch, sz_ch, STONE_BG)
					if noise.value_noise_1D(x_global / 10.0) > lerp(.5, 1, (y_global - 93)/(96 - 93)) - .2:
						create_tile(x, y, STONE)
					else:
						create_tile(x, y, STONE_DARK)
				else:
					# y = 96 to 127
					create_background(sz_ch, sz_ch, STONE_DARK_BG)
					create_tile(x, y, STONE_DARK)
			y += 1
		x += 1
	
	# generate caves
	x = 0
	y = 0
	while x < sz_ch:
		y = 0
		while y < sz_ch:
			var x_global = ch_index.x*sz_ch + x
			var y_global = ch_index.y*sz_ch + y
			if y_global >= cave_depth and  y_global < tunnel_depth:
				# y = 16 to 111
				if y_global < 32:
					# y = 16 to 31
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) > lerp(1, .5, (y_global - 16)/(31 - 16)):
						create_tile(x, y, AIR)
				elif y_global < 96:
					# y = 32 to 95
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) > .5:
						create_tile(x, y, AIR)
				else:
					# y = 96 to 111
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) > lerp(.5, 1, (y_global - 96)/(111 - 96)):
						create_tile(x, y, AIR)
			y += 1
		x += 1


func create_debug_overlay():
	var scn_overlay = load("res://instances/Debug_Overlay_Chunk.tscn").instance()
	
	scn_overlay.add_stat("pos_ch", self, "pos_ch", false, null)
	scn_overlay.draw_chunk_border(sz_ch)
	add_child(scn_overlay)

func create_tile(x: int, y: int, type: int):
	$TileMap.set_cell(x, y, type)
	tl_types[x][y] = type

func create_background(width, height, type):
	return
	var new_background = background_scn.instance()
	new_background.background_type = type
	new_background.width = width*16
	new_background.height = height*16
	add_child(new_background)
