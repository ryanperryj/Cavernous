extends Node

var world_num: int
var world_seed_str: String

const sz_tl: int = 16 # px
const sz_ch: int = 16 # tl

const AIR = Vector2(-1,-1)

const DIRT = Vector2(0,0)
const STONE_DIRTY = Vector2(1,0)
const STONE = Vector2(2,0)
const STONE_DARK = Vector2(3,0)
