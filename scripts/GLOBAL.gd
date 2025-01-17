extends Node

const PLAYER = preload("res://scenes/player.tscn")
const PATH = "user://save.txt"

var game_started: bool
var player_alive: bool

# // PLAYER STATS //
var essence:float # health
var aether:float # mana 

var necrotic_power:int # strength
var ethereal_dexterity:int # agility
var corporeal_fortitude:int # vitality
var arcane_knowledge:int # intelligence
var dread_will:int # willpower

# // POWERS & SPELLS //
var phylactery_bond:float # stat tied to how much damage the player can transfer to or absorb from the phylactery
var dark_influence:float # 

# // WORLD STATS
var room_counter:int
var game_time:float


# // SAVE FUNCTIONALITY //
var data: Dictionary = {
	"version": "0.0.1",
	"master": 100.0,
	"music": 100.0,
	"sfx": 100.0,
}

@onready var default_data: Dictionary = data

func save_data() -> void:
	var file: FileAccess = FileAccess.open(PATH, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_data() -> void:
	var file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	if !FileAccess.file_exists(PATH):
		return
	var saved_data: Variant = file.get_var()
	data = saved_data
	file.close()

func reset_data() -> void:
	data = default_data
	save_data()
	get_tree().reload_current_scene()
