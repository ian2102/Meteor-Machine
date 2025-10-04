extends Node

const LAUNCH = preload("res://Scenes/launch.tscn")
const LEARN = preload("res://Scenes/learn.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("quit"):
		get_tree().quit()


func _on_learn_button_down() -> void:
	var learn = LEARN.instantiate()
	add_child(learn)

func _on_launch_button_down() -> void:
	var launch = LAUNCH.instantiate()
	add_child(launch)
