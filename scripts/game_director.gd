class_name GameDirector extends Node

var room_count:= 0
var map:= {}
var x:= 0
var y:= 0

func _ready() -> void:
	create_starting_map()

func create_starting_map():
	map[1]= {}
	map[0]= {}
	map[-1]= {}
	map[0][0]= 'phylactery'
	var room_ids:= ['desert', 'plains', 'ruins', 'jungle', 'swamp', 'alpine', 'badlands', 'hell']
	room_ids.shuffle()
	map[0][1]= room_ids.pop_front()
	map[1][1]= room_ids.pop_front()
	map[1][0]= room_ids.pop_front()
	map[1][-1]= room_ids.pop_front()
	map[0][-1]= room_ids.pop_front()
	map[-1][-1]= room_ids.pop_front()
	map[-1][0]= room_ids.pop_front()
	map[-1][1]= room_ids.pop_front()

func get_room_id(new_x: int, new_y: int) -> String:
	print(str('x:', x, ' y:', y))
	if(map.has(new_x) && map[x].has(new_y)):
		x = new_x
		y = new_y
		return map[x][y]
	return 'invalid'

func load_map(target_map: Dictionary):
	map = target_map

func change_room(exit: Vector2, transition_type):
	print(str(exit))
	var destination_id = get_room_id(x + floori(exit.x), floori(y + exit.y))
	print(destination_id)
	if(destination_id != 'invalid'):
		if transition_type == "zelda":
			SceneManagerSingle.load_level_zelda(destination_id)
		else:
			SceneManagerSingle.load_new_scene(destination_id, transition_type)
