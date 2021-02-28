extends Control

var dir = Directory.new()

func _ready():
	if dir.file_exists("user://saves/world_1.dat"):
		$ColorRect/World1Button/Label.text = "World 1"
		$ColorRect/XWorld1Button.disabled = false
		$ColorRect/XWorld1Button.visible = true
	if dir.file_exists("user://saves/world_2.dat"):
		$ColorRect/World2Button/Label.text = "World 2"
		$ColorRect/XWorld2Button.disabled = false
		$ColorRect/XWorld2Button.visible = true
	if dir.file_exists("user://saves/world_3.dat"):
		$ColorRect/World3Button/Label.text = "World 3"
		$ColorRect/XWorld3Button.disabled = false
		$ColorRect/XWorld3Button.visible = true
	if dir.file_exists("user://saves/world_4.dat"):
		$ColorRect/World4Button/Label.text = "World 4"
		$ColorRect/XWorld4Button.disabled = false
		$ColorRect/XWorld4Button.visible = true


func _on_World1Button_pressed():
	Globals.world_num = 1
	if dir.file_exists("user://saves/world_1.dat"):
		get_tree().change_scene("res://scenes/World.tscn")
	else:
		get_tree().change_scene("res://scenes_ui/World_Create.tscn")

func _on_World2Button_pressed():
	Globals.world_num = 2
	if dir.file_exists("user://saves/world_2.dat"):
		get_tree().change_scene("res://scenes/World.tscn")
	else:
		get_tree().change_scene("res://ui/World_Create.tscn")

func _on_World3Button_pressed():
	Globals.world_num = 3
	if dir.file_exists("user://saves/world_3.dat"):
		get_tree().change_scene("res://scenes/World.tscn")
	else:
		get_tree().change_scene("res://scenes_ui/World_Create.tscn")

func _on_World4Button_pressed():
	Globals.world_num = 4
	if dir.file_exists("user://saves/world_4.dat"):
		get_tree().change_scene("res://scenes/World.tscn")
	else:
		get_tree().change_scene("res://scenes_ui/World_Create.tscn")


func _on_XWorld1Button_pressed():
	dir.remove("user://saves/world_1.dat")
	$ColorRect/World1Button/Label.text = "Empty"
	$ColorRect/XWorld1Button.disabled = true
	$ColorRect/XWorld1Button.visible = false

func _on_XWorld2Button_pressed():
	dir.remove("user://saves/world_2.dat")
	$ColorRect/World2Button/Label.text = "Empty"
	$ColorRect/XWorld2Button.disabled = true
	$ColorRect/XWorld2Button.visible = false

func _on_XWorld3Button_pressed():
	dir.remove("user://saves/world_3.dat")
	$ColorRect/World3Button/Label.text = "Empty"
	$ColorRect/XWorld3Button.disabled = true
	$ColorRect/XWorld3Button.visible = false

func _on_XWorld4Button_pressed():
	dir.remove("user://saves/world_4.dat")
	$ColorRect/World4Button/Label.text = "Empty"
	$ColorRect/XWorld4Button.disabled = true
	$ColorRect/XWorld4Button.visible = false

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes_ui/Title.tscn")
