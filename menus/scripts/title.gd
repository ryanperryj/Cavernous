extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://menus/scenes/World_Select.tscn")


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
