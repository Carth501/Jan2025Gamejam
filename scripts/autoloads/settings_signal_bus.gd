extends Node

signal on_subtitles_toggled(value: bool)
signal on_window_mode_selected(index: int)
signal on_resolution_selected(index: int)
signal on_sound_master_set(value: float)
signal on_sound_music_set(value: float)
signal on_sound_sfx_set(value: float)
signal on_sound_voice_set(value: float)
signal set_settings_dictionary(settings_dict: Dictionary)

func emit_set_settings_dictionary(settings_dict: Dictionary) -> void:
	set_settings_dictionary.emit(settings_dict)

func emit_on_subtittles_toggled(value: bool) -> void:
	on_subtitles_toggled.emit(value)

func emit_on_window_mode_selected(index: int) -> void:
	on_window_mode_selected.emit(index)

func emit_on_resolution_selected(index: int) -> void:
	on_resolution_selected.emit(index)

func emit_on_sound_master_set(value: bool) -> void:
	on_sound_master_set.emit(value)

func emit_on_sound_music_set(value: bool) -> void:
	on_sound_music_set.emit(value)

func emit_on_sound_sfx_set(value: bool) -> void:
	on_sound_sfx_set.emit(value)

func emit_on_sound_voice_set(value: bool) -> void:
	on_sound_voice_set.emit(value)
