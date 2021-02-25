extends Node

var world_num: int
var world_seed_str: String

const sz_tl: int = 16 # px
const sz_ch: int = 16 # tl

const AIR = -1

enum {
	DIRT, STONE_DIRTY, STONE, STONE_DARK
}
