extends CollisionShape2D

signal player_entered_door(door:Door,transition_type:String)

@export_enum("north","east","south","west") var entry_direction
@export_enum("fade_to_black","wipe_to_right","zelda") var transition_type:String
@export var push_distance:int = 16
@export var path_to_new_scene:String
@export var entry_door_name:String

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player_entered_door.emit(self)
	if transition_type == "zelda":
		SceneManager.load_level_zelda(path_to_new_scene)
	else:
		SceneManager.load_new_scene(path_to_new_scene,transition_type)
	queue_free()
# UTILITY FUNCTIONS

# returns the starting location of the player based on this door's location and the
# entry_direction (the Vector towards the room)
func get_player_entry_vector() - Vector2:
	pass

# inverts entry direction to determine the direction player would have been moving
# when they entered the room
func get_move_dir() -> Vector2:
	pass
