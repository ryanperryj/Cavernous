extends Control



func _on_BackButton_pressed():
	get_tree().change_scene("res://ui/World_Select.tscn")


func _on_CreateButton_pressed():
	Globals.world_seed_str = $ColorRect/SeedLineEdit.text
	get_tree().change_scene("res://scenes/World.tscn")
