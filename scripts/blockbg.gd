extends StaticBody2D

var blockbg_sprites = [
	preload("res://assets/blockbg/stone_bg.png"),
]

var blockbg_type

func _ready():
	$Sprite.texture = blockbg_sprites[blockbg_type]
