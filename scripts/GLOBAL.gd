extends Node

const PLAYER = preload("res://scenes/player.tscn")
const PATH = "user://save.txt"

#	//--DEBUG--//
const DEBUG: bool = true
const DEBUG_LEVEL: int = 0
const INFO: int = 0
const WARNING: int = 1
const ERROR: int = 2

#	//--GAME VARIABLES--//
var game_started: bool
var player_alive: bool

#	//--PLAYER STATS--//
var essence:float # health
var aether:float # mana 

var necrotic_power:int # strength
var ethereal_dexterity:int # agility
var corporeal_fortitude:int # vitality
var arcane_knowledge:int # intelligence
var dread_will:int # willpower

#	//--POWERS & SPELLS--//
var phylactery_bond:float # stat tied to how much damage the player can transfer to or absorb from the phylactery
var dark_influence:float # 

#	//--WORLD STATS--//
var room_counter:int
var game_time:float


#	//--SAVE FUNCTIONALITY--//
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

#	//--DEBUG FUNCTIONS--//
func debug(level:int,text:String) -> void:
	if DEBUG and level >= DEBUG_LEVEL:
		match level:
			INFO:
				print("[INFO] " + text)
			WARNING:
				print("[WARNING] " + text)
			ERROR:
				print("[ERROR] " + text)
			_:
				print("[UNKNOWN LEVEL] " + text)
