extends Node2D

var background_sprites = [
	preload("res://assets/background/0_dirt_bg.png"),
	preload("res://assets/background/1_stone_dirty_bg.png"),
	preload("res://assets/background/2_stone_bg.png"),
	preload("res://assets/background/3_stone_dark_bg.png"),
	preload("res://assets/background/4_stone_light_bg.png"),
]

var background_type
var width
var height

func _ready():
	$Sprite.texture = background_sprites[background_type]
	$Sprite.region_rect = Rect2(0, 0, width, height)
