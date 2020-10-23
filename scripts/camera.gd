extends Camera2D

var scn_pause = preload("res://ui/Pause.tscn")

var pause = scn_pause.instance()

signal save

func _ready():
	pause.connect("unpause", self, "_unpause")


func _process(delta):
	if Input.is_action_pressed("zoom_in"):
		zoom.x = clamp(zoom.x - .05, .1, 10)
		zoom.y = clamp(zoom.y - .05, .1, 10)
	if Input.is_action_pressed("zoom_out"):
		zoom.x = clamp(zoom.x + .05, .1, 10)
		zoom.y = clamp(zoom.y + .05, .1, 10)


func _input(event):
	if event.is_action_pressed("pause"):
		print("Camera: paused ; emitted signal 'save'")
		emit_signal("save")
		pause.rect_scale = zoom
		add_child(pause)
		get_tree().paused = true

func _unpause():
	print("Camera: unpaused")
	remove_child(pause)
