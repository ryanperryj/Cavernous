extends StaticBody2D

var block_sprites = [
	preload("res://assets/block/stone.png"),
	preload("res://assets/block/moss.png"),
]

var block_type

func _ready():
	$Sprite.texture = block_sprites[block_type]
