class_name Enemy extends CharacterBody2D

@export var stats: Stats
@export var SPEED:= 200.0
@export var DAMAGE:= 2.0
var player: Player
@export var attack_ready:= true
@export var attack_cooldown:= 0.5
var cooldown_timer: Timer

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time= attack_cooldown
	cooldown_timer.one_shot= true
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(ready_to_attack)

func set_player(new_player: Player):
	player = new_player

func ready_to_attack():
	attack_ready = true

func _process(delta: float) -> void:
	move_and_slide()
	if(player != null):
		var vector_to = player.position - position
		if(vector_to.length() < 80 && attack_ready):
			velocity = Vector2.ZERO
			player.stats.takeDamage(DAMAGE)
			attack_ready = false
			cooldown_timer.start()
		else:
			velocity = vector_to.normalized() * SPEED
	
