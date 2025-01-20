class_name MainMenu extends Control
@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/OptionsButton as Button
@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/QuitButton as Button
@onready var options_menu = $Options_Menu as OptionsMenu

@onready var margin_container = $MarginContainer as MarginContainer

#@onready var main_scene = preload("") as PackedScene


func _ready() -> void:
	start_button.grab_focus()
	handle_connecting_signals()

func _on_start_button_pressed() -> void:
	Global.debug(0,"Start the game.")
	#get_tree().change_scene_to_packed()
	

func _on_options_button_pressed() -> void:
	Global.debug(0,"Open options menu")
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_quit_button_pressed() -> void:
	Global.debug(0,"Quit the game")
	get_tree().quit()

func on_exit_options_menu() -> void:
	options_menu.visible = false
	margin_container.visible = true


func handle_connecting_signals() -> void:
	options_menu.exit_options_menu.connect(on_exit_options_menu)
