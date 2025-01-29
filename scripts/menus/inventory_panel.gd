class_name InventoryPanel extends PanelContainer

@export var resource_list: GridContainer
@export var capacity_bar: ProgressBar
var existing_buttons:= {}
@export var capacity_limit:= 0.0

func _ready() -> void:
	if(capacity_limit > 0.0):
		capacity_bar.visible = true
	else:
		capacity_bar.visible = false

func display_inventory(new_inv: Dictionary):
	for item_id in new_inv:
		if(IdTablesSingle.items.has(item_id)):
			if(!existing_buttons.has(item_id)):
				var icon_path = IdTablesSingle.items[item_id].icon_path
				var new_button = Button.new()
				new_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
				var image = load(icon_path)
				new_button.icon = image
				existing_buttons[item_id] = new_button
				resource_list.add_child(new_button)
			existing_buttons[item_id].visible = new_inv[item_id] > 0
			existing_buttons[item_id].text = str(new_inv[item_id])
			
