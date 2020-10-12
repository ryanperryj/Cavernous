extends Node2D

var background_sprites = [
	preload("res://assets/background/stone_bg.png"),
]

var background_type
var width
var height

func _ready():
	$Sprite.texture = background_sprites[background_type]
	$Sprite.offset.y = (height - 16)/2
	$Sprite.offset.x = (width - 16)/2
	$Sprite.region_rect = Rect2(0, 0, width, height)
