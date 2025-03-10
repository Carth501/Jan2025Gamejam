class_name SceneManager extends Node

const LEVEL_H:int = 648
const LEVEL_W:int = 1152

signal content_finished_loading(content)
signal zelda_content_finished_loading(content)
signal content_invalid(content_path:String)
signal content_failed_to_load(content_path:String)

var loading_screen:LoadingScreen
var _loading_screen_scene:PackedScene = preload("res://scenes/loading_screen.tscn")
var _transition:String
var _content_path:String
var _load_progress_timer:Timer

func _ready() -> void:
	_load_progress_timer = Timer.new()
	add_child(_load_progress_timer)
	_load_progress_timer.timeout.connect(monitor_load_status)
	content_invalid.connect(on_content_invalid)
	content_failed_to_load.connect(on_content_failed_to_load)
	content_finished_loading.connect(on_content_finished_loading)
	zelda_content_finished_loading.connect(on_zelda_content_finished_loading)

func load_new_scene(level_id:String, transition_type:String="fade_to_black") -> void:
	_transition = transition_type
	# add loading screen
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	loading_screen.start_transition(transition_type)
	_load_content(level_id)

func load_level_zelda(level_id:String) -> void:
	_transition = "zelda"
	_load_content(level_id)

func _load_content(level_id:String) -> void:
	_content_path = dereference(level_id)
	 
	# zelda transition doesn't use a loading screen
	if loading_screen != null:
		await loading_screen.transition_in_complete

	var loader = ResourceLoader.load_threaded_request(_content_path)
	if not ResourceLoader.exists(_content_path) or loader == null:
		content_invalid.emit(_content_path)
		return

	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.start()

func monitor_load_status() -> void:
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			content_invalid.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if loading_screen != null:
				loading_screen.update_bar(load_progress[0] * 100)
		ResourceLoader.THREAD_LOAD_FAILED:
			content_failed_to_load.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			if _transition == "zelda":
				zelda_content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			else:
				content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			return

func on_content_failed_to_load(path:String) -> void:
	printerr("error: Failed to load resource: '%s'" % [path])

func on_content_invalid(path:String) -> void:
	printerr("error: Cannot load resource: %s'" % [path])

func on_content_finished_loading(content) -> void:
	var outgoing_scene = get_tree().current_scene
	
	# If we're moving between Levels, pass LevelDataHandoff here
	var incoming_data:LevelDataHandoff
	if get_tree().current_scene is Level:
		incoming_data = get_tree().current_scene.data as LevelDataHandoff
	
	if content is Level:
		content.receive_data(incoming_data)
	
	# Remove the old scene
	outgoing_scene.queue_free()
	
	# Add and set the new scene to current
	get_tree().root.call_deferred("add_child",content)
	get_tree().set_deferred("current_scene", content)
	
	# probably not necssary since we split out content_finished_loading but it won't hurt to have an extra check
	if loading_screen != null:
		loading_screen.finish_transition()
		# e.g. will be skipped if we're loading a menu instead of a game level
		if content is Level:
			content.init_player_location()
		# wait for LoadingScreen's transition to finish playing
		await loading_screen.anim_player.animation_finished
		loading_screen = null
		
		if content is Level:
			content.enter_level()
			content.activate_doors()

func on_zelda_content_finished_loading(content) -> void:
	var outgoing_scene = get_tree().current_scene
	# If we're moving between levels, pass LevelDataHandoff here
	
	var incoming_data:LevelDataHandoff
	if get_tree().current_scene is Level:
		incoming_data = get_tree().current_scene.data as LevelDataHandoff
	
	if content is Level:
		content.data = incoming_data
	
	# slide new level in
	content.position.x = incoming_data.move_dir.x * LEVEL_W
	content.position.y = incoming_data.move_dir.y * LEVEL_H
	var tween_in:Tween = get_tree().create_tween()
	tween_in.tween_property(content, "position", Vector2.ZERO, 1).set_trans(Tween.TRANS_SINE)
	
	# slide old level out
	var tween_out:Tween = get_tree().create_tween()
	var vector_off_screen:Vector2 = Vector2.ZERO
	vector_off_screen.x = -incoming_data.move_dir.x * LEVEL_W
	vector_off_screen.y = -incoming_data.move_dir.y * LEVEL_H
	tween_out.tween_property(outgoing_scene, "position", vector_off_screen, 1).set_trans(Tween.TRANS_SINE)
	
	# add new scene to the tree
	get_tree().root.call_deferred("add_child",content)
	
	# once the tweens are done, do some cleanup
	await tween_in.finished
	
	#skipping if not a Level
	if content is Level:
		content.init_player_location()
		content.enter_level()
		content.activate_doors()
	
	# Remove the old scene
	outgoing_scene.queue_free()
	# Add and set the new scene to current
	get_tree().current_scene = content

func dereference(level_id: String):
	if(IdTablesSingle.levels.has(level_id)):
		return IdTablesSingle.levels[level_id].path
	else:
		push_error(str("invalid level_id ", level_id))
