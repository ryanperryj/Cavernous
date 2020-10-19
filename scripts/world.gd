extends Node2D

# TYPES
# px: pixel
# tl: tile
# ch: chunk

# QUALIFIERS
# cur: current
# rel: relative
# sel: selected

# DATA
# sz: size
# pos: position
# ptr: pointer
# scn: scene
# scr: script

# data_qualifier_type

const world_num: int = 1

const SAVE_DIR = "user://saves/"
const SAVE_PATH = "user://saves/world_" + str(world_num) + ".dat"

var scn_ch = preload("res://instances/Chunk.tscn")

enum {
	PX, TL, CH
}

const sz_tl: int = 16			#px
const sz_ch: int = 16			#tl
const load_distance: int = 2	#ch
const world_depth: int =  8		#ch

export var seed_str = "oliver"

var pos_cur_px: Vector2
var pos_cur_tl: Vector2
var pos_cur_ch: Vector2

var pos_sel_px: Vector2
var pos_sel_tl: Vector2
var pos_sel_ch: Vector2

var ch_loaded_ptr = {}
var tl_types = {}

var world_done_loading = false

func _ready():
	# load world data
	set_process(false)
	var save_file = File.new()
	if save_file.file_exists(SAVE_PATH):
		var save_file_open_error = save_file.open(SAVE_PATH, File.READ)
		# handle file opening error
		if save_file_open_error != OK:
			print("error at file open")
			get_tree().quit()
		tl_types = save_file.get_var()
		print("world loaded")
		save_file.close()
	set_process(true)
	
	# generate debug overlay
	var scn_overlay = load("res://scenes/Debug_Overlay.tscn").instance()
	scn_overlay.add_stat("Player Position", $Player, "position", false, null)
	scn_overlay.add_stat("Player Tile", self, "get_pos_curr", true, TL)
	scn_overlay.add_stat("Player Chunk", self, "get_pos_curr", true, CH)
	add_child(scn_overlay)

func _process(delta):
	pos_cur_px = $Player.position.floor()
	pos_cur_tl = (pos_cur_px / sz_tl).floor()
	pos_cur_ch = (pos_cur_tl / sz_ch).floor()

	pos_sel_px = get_global_mouse_position().floor()
	pos_sel_tl = (pos_sel_px / sz_tl).floor()
	pos_sel_ch = (pos_sel_tl / sz_ch).floor()
	
	# load chunks
	for x in range(-load_distance, load_distance + 1):
		for y in range(-load_distance, load_distance + 1):
			var pos_ch = pos_cur_ch + Vector2(x, y)
			# continue if not in the world bounds
			if pos_ch.y < 0 or pos_ch.y > world_depth - 1:
				continue
			# instance if it isn't currently instanced
			if !ch_loaded_ptr.has(pos_ch):
				ch_loaded_ptr[pos_ch] = scn_ch.instance()
				ch_loaded_ptr[pos_ch].pos_ch = pos_ch
				ch_loaded_ptr[pos_ch].translate(pos_ch*sz_ch*sz_tl)
				# load chunk if chunk has been generated before 
				if tl_types.has(pos_ch):
					ch_loaded_ptr[pos_ch].load_from_mem(sz_ch, tl_types[pos_ch])
				# else, generate new chunk
				else:
					ch_loaded_ptr[pos_ch].generate(sz_ch, seed_str)
					tl_types[pos_ch] = ch_loaded_ptr[pos_ch].tl_types
				call_deferred("add_child", (ch_loaded_ptr[pos_ch]))
	
	# unload chunks
	for x in range(-load_distance - 1, load_distance + 2):
		for y in range(-load_distance - 1, load_distance + 2):
			if x == -load_distance - 1 or x == load_distance + 1 or y == -load_distance - 1 or y == load_distance + 1:
				var pos_ch = pos_cur_ch + Vector2(x, y)
				if ch_loaded_ptr.has(pos_ch):
					ch_loaded_ptr[pos_ch].queue_free()
					ch_loaded_ptr.erase(pos_ch)

func get_pos_rel_tile(pos_tl: Vector2) -> Vector2:
	var pos_ch = (pos_tl / sz_ch).floor()
	return pos_tl - pos_ch*sz_ch

func get_tile_type(pos_tl: Vector2) -> int:
	var pos_ch = (pos_tl / sz_ch).floor()
	var pos_tl_rel_ch = pos_tl - pos_ch*sz_ch
	
	if tl_types.has(pos_ch):
		return tl_types[pos_ch][pos_tl_rel_ch]
	else:
		return -2

func get_pos_curr(frame):
	match frame:
		PX:
			return pos_cur_px
		TL:
			return pos_cur_tl
		CH:
			return pos_cur_ch
	return Vector2.ZERO

func _input(event):
	if event.is_action_released("quit"):
		get_tree().quit()
	if event.is_action_released("reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("save_game"):
		var save_dir = Directory.new()
		if !save_dir.dir_exists(SAVE_DIR):
			save_dir.make_dir_recursive(SAVE_DIR)
		var save_file = File.new()
		var save_file_open_error = save_file.open(SAVE_PATH, File.WRITE)
		# handle file opening error
		if save_file_open_error != OK:
			print("error at file open")
			get_tree().quit()
		save_file.store_var(tl_types)
		save_file.close()
		print("world saved")
	if event.is_action_pressed("break_tile"):
		if ch_loaded_ptr.has(pos_sel_ch):
			var pos_rel_tl = get_pos_rel_tile(pos_sel_tl)
			ch_loaded_ptr[pos_sel_ch].get_node("TileMap").set_cell(pos_rel_tl.x, pos_rel_tl.y, -1)
			tl_types[pos_sel_ch][pos_rel_tl] = -1
