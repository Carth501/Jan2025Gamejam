class_name Enemy extends CharacterBody2D

@export var stats: Stats
@export var SPEED:= 100.0
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
	if(player != null):
		var vector_to = player.position - position
		velocity = vector_to.normalized() * SPEED
		move_and_slide()
		if(attack_ready):
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				if(collision.get_collider() == player):
					player.stats.takeDamage(DAMAGE)
					attack_ready = false
					cooldown_timer.start()

func detect_contact():
	return 
