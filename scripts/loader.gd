extends Node2D

var speed = 10.0
var input_vec = Vector2.ZERO

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("up"):
		translate(Vector2(0, -speed))
	if Input.is_action_pressed("down"):
		translate(Vector2(0, speed))
	if Input.is_action_pressed("left"):
		translate(Vector2(-speed, 0))
	if Input.is_action_pressed("right"):
		translate(Vector2(speed, 0))
	if Input.is_action_pressed("zoom_in"):
		speed = clamp(speed - .25, 4, 50)
		$camera.zoom.x = clamp($camera.zoom.x - .05, .1, 10)
		$camera.zoom.y = clamp($camera.zoom.y - .05, .1, 10)
	if Input.is_action_pressed("zoom_out"):
		speed = clamp(speed + .25, 4, 50)
		$camera.zoom.x = clamp($camera.zoom.x + .05, .1, 10)
		$camera.zoom.y = clamp($camera.zoom.y + .05, .1, 10)