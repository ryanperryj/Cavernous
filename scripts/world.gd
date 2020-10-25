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

var save_path = "user://saves/world_" + str(Globals.world_num) + ".dat"

var scn_ch = preload("res://instances/Chunk.tscn")

const sz_tl: int = 16			#px
const sz_ch: int = 16			#tl
const load_distance: int = 2	#ch
const world_depth: int =  8		#ch

var cur_pos: Vector2
var cur_tl: Vector2
var cur_ch: Vector2

var sel_pos: Vector2
var sel_tl: Vector2
var sel_ch: Vector2

var ch_loaded_ptr = {}
var tl_types = {}

var save_dict = {}

var world_done_loading = false

func _ready():
	# load world data
	set_process(false)
	var save_file = File.new()
	if save_file.file_exists(save_path):
		var save_file_open_error = save_file.open(save_path, File.READ)
		# handle file opening error
		if save_file_open_error != OK:
			print("World: error at file open for loading")
			get_tree().quit()
		save_dict = save_file.get_var()
		tl_types = save_dict["tl_types"]
		Globals.world_seed_str = save_dict["world_seed_str"]
		print("World: loaded ; world number = ", Globals.world_num, " ; seed string = '",  Globals.world_seed_str, "'")
		save_file.close()
	else:
		print("World: created ; world number = ", Globals.world_num, " ; seed string = '",  Globals.world_seed_str, "'")
	set_process(true)
	
	# generate debug overlay
	var scn_overlay = load("res://scenes/Debug_Overlay.tscn").instance()
	scn_overlay.add_stat("Player Position", self, "get_cur_pos", false, null)
	scn_overlay.add_stat("Player Tile", self, "get_cur_tl", false, null)
	scn_overlay.add_stat("Player Chunk", self, "get_cur_ch", false, null)
	add_child(scn_overlay)

func _process(delta):
	cur_pos = $Player.position
	cur_tl = (cur_pos / sz_tl).floor()
	cur_ch = (cur_tl / sz_ch).floor()

	sel_pos = get_global_mouse_position()
	sel_tl = (sel_pos / sz_tl).floor()
	sel_ch = (sel_tl / sz_ch).floor()
	
	# load chunks
	for x in range(-load_distance, load_distance + 1):
		for y in range(-load_distance, load_distance + 1):
			var ch = cur_ch + Vector2(x, y)
			# continue if not in the world bounds
			if ch.y < 0 or ch.y > world_depth - 1:
				continue
			# instance if it isn't currently instanced
			if !ch_loaded_ptr.has(ch):
				ch_loaded_ptr[ch] = scn_ch.instance()
				ch_loaded_ptr[ch].ch_index = ch
				ch_loaded_ptr[ch].translate(ch*sz_ch*sz_tl)
				# load chunk if chunk has been generated before 
				if tl_types.has(ch):
					ch_loaded_ptr[ch].load_from_mem(sz_ch, tl_types[ch])
				# else, generate new chunk
				else:
					ch_loaded_ptr[ch].generate(sz_ch)
					tl_types[ch] = ch_loaded_ptr[ch].tl_types
				call_deferred("add_child", (ch_loaded_ptr[ch]))
	
	# unload chunks
	for x in range(-load_distance - 1, load_distance + 2):
		for y in range(-load_distance - 1, load_distance + 2):
			if x == -load_distance - 1 or x == load_distance + 1 or y == -load_distance - 1 or y == load_distance + 1:
				var ch = cur_ch + Vector2(x, y)
				if ch_loaded_ptr.has(ch):
					ch_loaded_ptr[ch].queue_free()
					ch_loaded_ptr.erase(ch)

func get_cur_pos():
	return cur_pos

func get_cur_tl():
	return cur_tl

func get_cur_ch():
	return cur_ch

func get_rel_tl(tl: Vector2) -> Vector2:
	var ch = (tl / sz_ch).floor()
	return tl - ch*sz_ch


func get_tl_type(tl: Vector2) -> int:
	var ch = (tl / sz_ch).floor()
	var tl_rel_ch = tl - ch*sz_ch
	
	if tl_types.has(ch):
		return tl_types[ch][tl_rel_ch.x][tl_rel_ch.y]
	else:
		return -2


func _input(event):
	if event.is_action_released("reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("break_tile"):
		if ch_loaded_ptr.has(sel_ch):
			var rel_tl = get_rel_tl(sel_tl)
			ch_loaded_ptr[sel_ch].get_node("TileMap").set_cell(rel_tl.x, rel_tl.y, -1)
			tl_types[sel_ch][rel_tl.x][rel_tl.y] = -1


func _on_Camera_save():
	var save_dir = Directory.new()
	if !save_dir.dir_exists("user://saves/"):
		save_dir.make_dir_recursive("user://saves/")
	var save_file = File.new()
	var save_file_open_error = save_file.open(save_path, File.WRITE)
	# handle file opening error
	if save_file_open_error != OK:
		print("World: error at file open for saving")
		get_tree().quit()
	save_dict["tl_types"] = tl_types
	save_dict["world_seed_str"] = Globals.world_seed_str
	save_file.store_var(save_dict)
	save_file.close()
	print("World: saved")
