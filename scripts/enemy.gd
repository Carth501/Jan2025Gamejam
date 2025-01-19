class_name Enemy extends CharacterBody2D

@export var stats:Stats
@export var SPEED := 200.0
var player: Player

func set_player(new_player: Player):
	player = new_player

func _process(delta: float) -> void:
	move_and_slide()
	if(player != null):
		var vector_to = player.position - position
		if(vector_to.length() < 20):
			velocity = Vector2.ZERO
		else:
			velocity = vector_to.normalized() * SPEED
	
