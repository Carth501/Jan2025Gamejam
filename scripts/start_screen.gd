class_name StartScreen extends Control

func _on_button_button_up() -> void:
	SceneManagerSingle.load_new_scene("res://scenes/level_.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneManagerSingle.load_new_scene("res://scenes/level_.tscn")
