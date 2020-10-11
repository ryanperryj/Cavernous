extends StaticBody2D

var background_sprites = [
	preload("res://assets/background/stone_bg.png"),
]

var background_type

func _ready():
	$Sprite.texture = background_sprites[background_type]
