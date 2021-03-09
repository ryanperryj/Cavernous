extends Camera2D

var scn_pause = preload("res://menus/scenes/Pause.tscn")
var scn_inventory = preload("res://inventory/scenes/Inventory_Container.tscn")

var pause = scn_pause.instance()
var inventory_screen = scn_inventory.instance()

var inventory_open = false

signal save

func _ready():
	pause.connect("unpause", self, "_unpause")
	pause.offset = get_viewport_transform() * (get_global_transform() * position)


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
		add_child(pause)
		get_tree().paused = true
		
		inventory_open = false
		print("Camera: inventory closed")
		remove_child(inventory_screen)
	
	if event.is_action_pressed("open_inventory"):
		if inventory_open:
			inventory_open = false
			print("Camera: inventory closed")
			remove_child(inventory_screen)
		else:
			inventory_open = true
			print("Camera: inventory opened")
			add_child(inventory_screen)

func _unpause():
	print("Camera: unpaused")
	remove_child(pause)
