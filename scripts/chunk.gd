extends Node2D

var noise_scr = preload("res://scripts/noise.gd")

const sz_ch = Globals.sz_ch

var ch_index: Vector2
var cave_depth = 16
var tunnel_depth = 112

var tl_type = []

signal readied

func _ready():
	# init arrays
	var x = 0
	var y = 0
	while x < sz_ch:
		tl_type.append([])
		y = 0
		while y < sz_ch:
			tl_type[x].append(Globals.AIR)
			y += 1
		x += 1
	
	emit_signal("readied")


func load_from_mem(tl_type_from_mem):
	yield(self, "readied")
	var x = 0
	var y = 0
	while x < sz_ch:
		y = 0
		while y < sz_ch:
			create_tile(x, y, tl_type_from_mem[x][y])
			y += 1
		x += 1


func generate():
	yield(self, "readied")
	var noise = noise_scr.Noise.new(Globals.world_seed_str)
	# generate solid ground
	var x = 0
	var y = 0
	while x < sz_ch:
		y = 0
		while y < sz_ch:
			var x_global = ch_index.x*sz_ch + x
			var y_global = ch_index.y*sz_ch + y
			# top layer of solid stone
			if  y_global < cave_depth - 3:
				# y = 0 to 12
				create_tile(x, y, Globals.ASH)
			elif  y_global < cave_depth:
				# y = 13 to 15
				if noise.value_noise_1D(x_global / 10.0) > lerp(.5, 1, (y_global - 13)/(15 - 13)):
					create_tile(x, y, Globals.ASH)
				else:
					create_tile(x, y, Globals.ASH)
			else:
				# y = 16 to 127
				if y_global < 29:
					# y = 16 to 28
					create_tile(x, y, Globals.ASH)
				elif  y_global < 32:
					# y = 29 to 31
					if noise.value_noise_1D(x_global / 10.0) > lerp(.5, 1, (y_global - 29)/(31 - 29)) - .1:
						create_tile(x, y, Globals.ASH)
					else:
						create_tile(x, y, Globals.STONE)
				elif y_global < 93:
					# y = 32 to 92
					create_tile(x, y, Globals.STONE)
				elif y_global < 96:
					# y = 93 to 95
					if noise.value_noise_1D(x_global / 10.0) > lerp(.5, 1, (y_global - 93)/(96 - 93)) - .2:
						create_tile(x, y, Globals.STONE)
					else:
						create_tile(x, y, Globals.STONE_DARK)
				else:
					# y = 96 to 127
					create_tile(x, y, Globals.STONE_DARK)
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
			if y_global >= cave_depth and y_global < tunnel_depth:
				# y = 16 to 111
				if y_global < 32:
					# y = 16 to 31
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) > lerp(1, .5, (y_global - 16)/(31 - 16)):
						create_tile(x, y, Globals.AIR)
				elif y_global < 96:
					# y = 32 to 95
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) > .5:
						create_tile(x, y, Globals.AIR)
				else:
					# y = 96 to 111
					if noise.value_noise_2D(x_global / 10.0, y_global / 10.0) > lerp(.5, 1, (y_global - 96)/(111 - 96)):
						create_tile(x, y, Globals.AIR)
			y += 1
		x += 1


func create_debug_overlay():
	var scn_overlay = load("res://instances/Debug_Overlay_Chunk.tscn").instance()
	
	scn_overlay.add_stat("ch_index", self, "ch_index", false, null)
	scn_overlay.draw_chunk_border()
	add_child(scn_overlay)


func create_tile(x: int, y: int, type: Vector2):
	if type == Globals.AIR:
		$TileMap.set_cell(x, y, -1)
	else:
		$TileMap.set_cell(x, y, 0, false, false, false, type)
	tl_type[x][y] = type
