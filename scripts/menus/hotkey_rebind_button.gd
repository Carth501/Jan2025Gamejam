class_name HotkeyRebindButton extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button
#@onready var button_2 = $HBoxContainer/Button2 as Button

@export_enum("left","up","right","down","attack","interact") var action_name: String = "left"

func _ready():
	Global.debug(0,"HotkeyRebindButton initialized with action: %s" % action_name)
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"left":
			label.text = "Move Left"
		"right":
			label.text = "Move Right"
		"up":
			label.text = "Move Up"
		"down":
			label.text = "Move Down"
		"attack":
			label.text = "Attack"
		"interact":
			label.text = "Interact"
	Global.debug(0,"Action name set to %s" % label.text)

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	if action_events.size() == 0:
		Global.debug(1, "No input events found for action: %s" % action_name)
		button.text = "Unassigned"
		return  # No events, nothing to process

	var action_event = action_events[0]
	var action_keycode = ""
	
	## Get the input string depending on the event type
	if action_event is InputEventKey:
		action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	elif action_event is InputEventMouseButton:
		action_keycode = get_mouse_button_keycode(action_event.button_index)
	elif action_event is InputEventJoypadButton:
		action_keycode = "Joypad Button " + str(action_event.button_index)
	else:
		action_keycode = "Unknown Input"
	
	button.text = action_keycode  # Update the button text
	Global.debug(0, "Key text set to: %s for action: %s" % [action_keycode, action_name])

func get_mouse_button_keycode(button_index: int) -> String:
	match button_index:
		1:
			return "LMB"
		2:
			return "RMB"
		3:
			return "MMB"
		_:
			return "MB " + str(button_index)

func button_assignment(action_event: InputEvent, action_keycode: String) -> void:
	Global.debug(0, "Attempting to assign action: %s to keycode: %s" % [action_name,action_keycode])
	var is_duplicate = false

	# Check for duplicates
	for other_button in get_tree().get_nodes_in_group("hotkey_button"):
		if other_button.action_name != self.action_name and other_button.text == action_keycode:
			is_duplicate = true
			break

	if not is_duplicate:
		# Reassign the action event
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, action_event)

		# Update button text for the current instance
		self.button.text = action_keycode
		set_process_unhandled_key_input(false)
		set_text_for_key()
		set_action_name()
		Global.debug(0,"Action %s successfully reassigned to: %s" % [action_name,action_keycode])
	else:
		Global.debug(1, "Duplicate key assignment detected for: %s" % action_keycode)

func toggle_button(button_pressed: bool) -> void:
	Global.debug(0, "Toggling button for action: %s, state: %s" % [action_name, button_pressed])
	
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(true)

		# Disable other buttons in the group
		for other_button_node in get_tree().get_nodes_in_group("hotkey_button"):
			var other_button = other_button_node as HotkeyRebindButton  # Explicitly cast
			if other_button and other_button.action_name != self.action_name:
				other_button.button.toggle_mode = true
				other_button.set_process_unhandled_key_input(false)
	else:
		set_text_for_key()

		# Re-enable other buttons in the group
		for other_button_node in get_tree().get_nodes_in_group("hotkey_button"):
			var other_button = other_button_node as HotkeyRebindButton  # Explicitly cast
			if other_button and other_button.action_name != self.action_name:
				other_button.button.toggle_mode = true
				other_button.set_process_unhandled_key_input(false)


func _on_button_toggled(button_pressed: bool):
	toggle_button(button_pressed)

#func _on_button_2_toggled(button_pressed: bool):
	#toggle_button(button_pressed)

func _unhandled_key_input(event):
	Global.debug(1,"Unhandled input received: %s" % str(event))
	button.button_pressed = false

func rebind_action_key(event) -> void:
	Global.debug(0,"Rebinding action: %s to event: %s" % [action_name,str(event)])
	InputMap.action_erase_event(action_name, event)
	InputMap.action_add_event(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
