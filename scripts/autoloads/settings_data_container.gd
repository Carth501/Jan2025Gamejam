extends Node

var window_mode_index: int = 0
var resolution_index: int = 0
var master_volume: float = 0.0
var music_volume: float = 0.0
var sfx_volume: float = 0.0
var voice_volume: float = 0.0

func _ready():
	handle_signals()
	create_storage_dictionary()

func create_storage_dictionary() -> Dictionary:
	var settings_container_dict: Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolution_index" : resolution_index,
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume,
		"voice_volume" : voice_volume
	}
	Global.debug(0,"Storage dictionary created with values of %s" % settings_container_dict)
	return settings_container_dict

func on_window_mode_selected(index: int) -> void:
	window_mode_index = index

func on_resolution_selected(index: int) -> void:
	resolution_index = index

func on_master_volume_set(value: float) -> void:
	master_volume = value

func on_music_volume_set(value: float) -> void:
	music_volume = value

func on_sfx_volume_set(value: float) -> void:
	sfx_volume = value

func on_voice_volume_set(value: float) -> void:
	voice_volume = value

func handle_signals() -> void:
	SettingsSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingsSignalBus.on_resolution_selected.connect(on_resolution_selected)
	SettingsSignalBus.on_sound_master_set.connect(on_master_volume_set)
	SettingsSignalBus.on_sound_music_set.connect(on_music_volume_set)
	SettingsSignalBus.on_sound_sfx_set.connect(on_sfx_volume_set)
	SettingsSignalBus.on_sound_voice_set.connect(on_voice_volume_set)
