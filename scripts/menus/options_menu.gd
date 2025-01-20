class_name OptionsMenu extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/ExitButton as Button

signal exit_options_menu


func _ready():
	set_process(false)

func _on_exit_button_pressed() -> void:
	Global.debug(0,"Exit options menu")
	exit_options_menu.emit()
	set_process(false)
