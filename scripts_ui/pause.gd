extends Control

signal unpause

onready var flag = false

func _on_ContinueButton_pressed():
	_unpause()
	
func _input(event):
	if event.is_action_released("pause"):
		if flag:
			_unpause()
		else:
			flag = true

func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes_ui/Title.tscn")


func _unpause():
	get_tree().paused = false
	emit_signal("unpause")
	flag = false
