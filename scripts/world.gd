extends Node2D

# TYPES
# px: pixel
# tl: tile
# ch: chunk

# QUALIFIERS
# cur: current
# rel: relative

# DATA
# sz: size
# pos: position
# ptr: pointer
# scn: scene
# scr: script

# data_qualifier_type

var scn_ch = preload("res://instances/Chunk.tscn")

const sz_tl: int = 16			#px
const sz_ch: int = 16			#tl
const load_distance: int = 4	#ch
const world_depth: int =  8		#ch

export var seed_str = "oliver"

var pos_curr_px: Vector2
var pos_curr_tl: Vector2
var pos_curr_ch: Vector2
var pos_last_ch: Vector2

var ch_loaded_ptr = {}
var ch_is_generated = {}
var tl_types = {}

func _process(delta):
	pos_curr_px = $Player.position.floor()
	pos_curr_tl = (pos_curr_px / sz_tl).floor()
	pos_curr_ch = (pos_curr_tl / sz_ch).floor()
	
	# print current chunk
#	var row_text = ""
#	if tl_types.has(pos_curr_ch) and pos_curr_ch != pos_last_ch:
#		for y in range(sz_ch):
#			row_text = ""
#			for x in range(sz_ch):
#				row_text += str(tl_types[pos_curr_ch][y][x]) + "	"
#			print(row_text + "\n")
#		print("\n =========== \n")
#	pos_last_ch = pos_curr_ch
	
	# chunk loading
	for x in range(-load_distance, load_distance + 1):
		for y in range(-load_distance, load_distance + 1):
			var pos_ch = pos_curr_ch + Vector2(x, y)
			if pos_ch.y < 0 or pos_ch.y > world_depth - 1:
				continue
			if !ch_loaded_ptr.has(pos_ch):
				ch_loaded_ptr[pos_ch] = scn_ch.instance()
				ch_loaded_ptr[pos_ch].pos_ch = pos_ch
				ch_loaded_ptr[pos_ch].translate(pos_ch*sz_ch*sz_tl)
				call_deferred("add_child", (ch_loaded_ptr[pos_ch]))
				ch_is_generated[pos_ch] = true
				tl_types[pos_ch] = ch_loaded_ptr[pos_ch].tl_types
	
	# chunk unloading
	for x in range(-load_distance - 1, load_distance + 2):
		for y in range(-load_distance - 1, load_distance + 2):
			if x == -load_distance - 1 or x == load_distance + 1 or y == -load_distance - 1 or y == load_distance + 1:
				var pos_ch = pos_curr_ch + Vector2(x, y)
				if ch_loaded_ptr.has(pos_ch):
					ch_loaded_ptr[pos_ch].queue_free()
					ch_loaded_ptr.erase(pos_ch)

func get_tile_type(pos_tl: Vector2) -> int:
	var pos_ch = (pos_tl / sz_ch).floor()
	var pos_tl_rel_ch = pos_tl - pos_ch*sz_ch
	
	if tl_types.has(pos_ch):
		return tl_types[pos_ch][pos_tl_rel_ch]
	else:
		return -2

func load_chunk():
	pass

func generate_chunk():
	pass

func _input(event):
	if event.is_action_released("quit"):
		get_tree().quit()
	if event.is_action_released("reload"):
		get_tree().reload_current_scene()
	if event.is_action_released("enable_debug"):
		pass
