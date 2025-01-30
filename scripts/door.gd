class_name Door extends Area2D

signal player_entered_door(door:Door,transition_type:String)

@export_enum("north","east","south","west") var entry_direction
@export_enum("fade_to_black","fade_to_white","wipe_to_left","wipe_to_right","zelda") var transition_type:String
@export var push_distance:int = 16
@export var entry_door_name:String
@export var active:= false

func _on_body_entered(body: Node2D) -> void:
	if(!active):
		return
	if not body is Player:
		return
	player_entered_door.emit(self)
	GameDirectorSingle.change_room(get_direction(), transition_type)
# UTILITY FUNCTIONS

func get_direction():
	match entry_direction:
		0:
			return Vector2.UP
		1:
			return Vector2.RIGHT
		2:
			return Vector2.DOWN
		3:
			return Vector2.LEFT
		_:
			return Vector2.UP

# returns the starting location of the player based on this door's location and the
# entry_direction (the Vector towards the room)
func get_player_entry_vector() -> Vector2:
	var vector:Vector2 = Vector2.LEFT
	match entry_direction:
		0:
			vector = Vector2.UP
		1:
			vector = Vector2.RIGHT
		2:
			vector = Vector2.DOWN
	return (vector * push_distance) + self.position

# inverts entry direction to determine the direction player would have been moving
# when they entered the room
func get_move_dir() -> Vector2:
	var dir:Vector2 = Vector2.RIGHT
	match entry_direction:
		0:
			dir = Vector2.DOWN
		1:
			dir = Vector2.LEFT
		2:
			dir = Vector2.UP
	return dir

func activate():
	active = true

func deactivate():
	active = false
