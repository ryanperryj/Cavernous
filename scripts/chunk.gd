extends Node2D

var noise = preload("res://scripts/softnoise.gd")
var block = preload("res://instances/block.tscn")
var background = preload("res://instances/background.tscn")

enum {
	STONE, MOSS
}

var world_depth = 64
var world_height = 64
var cave_level = 64
var chunk_width = 32
var world_seed = 12345

func _ready():
	var softnoise = noise.SoftNoise.new(get_node(".").world_seed)
	for x in range(0, chunk_width):
		for y in range(-world_height, world_depth):
			create_background(Vector2(x*16, y*16), STONE)
		
		var cave_floor_y = floor(softnoise.openSimplex2D((get_global_transform().origin.x/16 + x)*.02, 0)*cave_level*.2)
		create_block(Vector2(x*16, cave_floor_y*16), MOSS)
		var cave_ceil_y = floor(softnoise.openSimplex2D((get_global_transform().origin.x/16 + x)*.05, 0)*10) - 20
		create_block(Vector2(x*16, cave_ceil_y*16), STONE)
		
		for y in range(cave_floor_y + 1, world_depth):
			create_block(Vector2(x*16, y*16), STONE)
		
		for y in range(-world_height, cave_ceil_y):
			create_block(Vector2(x*16, y*16), STONE)

func create_block(pos, type):
	var new_block = block.instance()
	new_block.translate(pos)
	new_block.block_type = type
	add_child(new_block)

func create_background(pos, type):
	var new_background = background.instance()
	new_background.translate(pos)
	new_background.background_type = type
	add_child(new_background)
