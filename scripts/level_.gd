class_name Level extends Node

@export var player:Player
var active_enemies: Array[Enemy]
var inactive_enemies: Array[Enemy]
@onready var enemy_prefab = preload("res://scenes/enemy.tscn")
@export var doors:Array[Door]
var seconds := 0
@export var level_extent: Vector2
@export var phil: Phylactery
@export var inventory_display: InventoryPanel
@export var phil_inventory_display: InventoryPanel
@export var enemies:= true
@export var room_danger_meter: ProgressBar
@export var upgrade_1: Button
@export var upgrade_2: Button

var data:LevelDataHandoff

func _ready() -> void:
	# if we aren't transition between levels, we don't need to wait for the SceneManager to call this
	if data == null:
		enter_level()

func enter_level() -> void:
	if data != null:
		init_player_location()
		player.upgrade_1 = data.upgrade_1
		player.upgrade_2 = data.upgrade_2
		update_upgrade_options()
	if(inventory_display != null):
		player.set_inventory_display(inventory_display)
	_connect_to_doors()
	activate_doors()

func receive_data(new_data: LevelDataHandoff):
	data = new_data

# put player in front of the correct door, facing the correct direction
func init_player_location() -> void:
	#var doors = find_children("*","Door")
	if data != null:
		for door in doors:
			if door.name == data.entry_door_name:
				player.position = door.get_player_entry_vector()
		player.orient(data.move_dir)
		player.set_inventory_display(inventory_display)
		player.activate()
		player.set_inventory(data.inventory)
		player.stats.current_health = data.player_health

# signal emitted by Door
# disables doors and players
# create handoff data to pass to the new scene (if new scene is a Level)
func _on_player_entered_door(door:Door) -> void:
	_disconnect_from_doors()
	player.deactivate()
	data = LevelDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	data.move_dir = door.get_move_dir()
	data.inventory = player.inventory
	data.player_health = player.stats.current_health
	data.upgrade_1 = player.upgrade_1
	data.upgrade_2 = player.upgrade_2
	set_process(false)

func _connect_to_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)

func _disconnect_from_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)

func spawn_enemies() -> void:
	if(!enemies):
		return
	var count_to_be_created = calculate_enemies_to_be_created()
	for r in count_to_be_created:
		spawn_single_enemy()

func spawn_single_enemy():
	var new_enemy
	if(inactive_enemies.size() > 0):
		new_enemy = inactive_enemies[0]
		inactive_enemies.remove_at(0)
	else:
		new_enemy = enemy_prefab.instantiate()
		new_enemy.position = get_random_spawn_point()
		new_enemy.dead.connect(deactivate)
		add_child(new_enemy)
		new_enemy.set_player(player)
	active_enemies.append(new_enemy)
	new_enemy.activate()
	new_enemy.set_level(seconds)

func increment():
	seconds += 1
	if(room_danger_meter != null):
		room_danger_meter.value = roundi((seconds * 0.8) / 1.8) + 20

func calculate_current_max_enemies() -> int:
	return floori((seconds / 3.0) + 20)

func calculate_enemies_to_be_created() -> int:
	var current_count = active_enemies.size()
	var target_count = calculate_current_max_enemies()
	var difference = ceili(( target_count - current_count ) / 4.0)
	return difference

func deactivate(enemy: Enemy):
	active_enemies.erase(enemy)
	inactive_enemies.append(enemy)
	enemy.teleport(get_random_spawn_point())

func get_random_spawn_point() -> Vector2:
	var edge_index = randi()% 4
	if(edge_index == 0):
		return Vector2(level_extent.x * randf(), 0)
	elif(edge_index == 1):
		return Vector2(0, level_extent.y * randf())
	elif(edge_index == 2):
		return Vector2(level_extent.x * randf(), level_extent.y)
	elif(edge_index == 3):
		return Vector2(level_extent.x, level_extent.y * randf())
	else:
		return Vector2.ZERO

func activate_doors():
	for door in doors:
		door.activate()

func purchase_upgrade_1():
	if(player.inventory.has("blood_drop") && player.inventory["blood_drop"]>=20):
		player.upgrade_1 = true
		player.inventory["blood_drop"]= player.inventory["blood_drop"]-20
		player.update_inventory_display()
		update_upgrade_options()

func purchase_upgrade_2():
	if(player.inventory.has("blood_drop") && player.inventory["blood_drop"]>=30):
		player.upgrade_2 = true
		player.inventory["blood_drop"]-=30
		player.update_inventory_display()
		update_upgrade_options()

func update_upgrade_options():
	if(upgrade_1 != null):
		if(player.upgrade_1):
			upgrade_1.disabled = true
		if(!player.inventory.has("blood_drop") || !player.inventory["blood_drop"]>=20):
			upgrade_1.disabled = true
	if(upgrade_2 != null):
		if(player.upgrade_2):
			upgrade_2.disabled = true
		if(!player.inventory.has("blood_drop") || !player.inventory["blood_drop"]>=30):
			upgrade_2.disabled = true
