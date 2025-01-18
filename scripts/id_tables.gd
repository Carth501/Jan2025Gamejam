extends Node

var levels : Dictionary
@export var level_data_path = "res://data/levels.json"

func _ready():
	levels = load_json_file(level_data_path)

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			push_error("error reading the actions file")
	else:
		push_error("actions file does not exist")
