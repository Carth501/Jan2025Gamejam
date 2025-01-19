class_name Level extends Node2D

@export var player:Player
var enemies: Array[Enemy]
@onready var enemy_prefab = preload("res://scenes/enemy.tscn")
@export var doors:Array[Door]

var data:LevelDataHandoff

func _ready() -> void:
	# if we aren't transition between levels, we don't need to wait for the SceneManager to call this
	if data == null:
		enter_level()
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.timeout.connect(spawn_enemy)
	timer.start()

func enter_level() -> void:
	if data != null:
		init_player_location()
	_connect_to_doors()

# put player in front of the correct door, facing the correct direction
func init_player_location() -> void:
	#var doors = find_children("*","Door")
	if data != null:
		for door in doors:
			if door.name == data.entry_door_name:
				player.position = door.get_player_entry_vector()
		player.orient(data.move_dir)

# signal emitted by Door
# disables doors and players
# create handoff data to pass to the new scene (if new scene is a Level)
func _on_player_entered_door(door:Door) -> void:
	_disconnect_from_doors()
	player.disable()
	player.queue_free()
	data = LevelDataHandoff.new()
	data.entry_door_name = door.entry_door_name
	data.move_dir = door.get_move_dir()
	set_process(false)

func _connect_to_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)

func _disconnect_from_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)

func spawn_enemy() -> void:
	print("spawn_enemy")
	var new_enemy = enemy_prefab.instantiate()
	add_child(new_enemy)
