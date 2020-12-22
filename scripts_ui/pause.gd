extends Control

signal unpause

func _on_ContinueButton_pressed():
	_unpause()


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://ui/Title.tscn")


func _unpause():
	get_tree().paused = false
	emit_signal("unpause")
