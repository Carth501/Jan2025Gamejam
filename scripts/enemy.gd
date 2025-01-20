class_name Enemy extends CharacterBody2D

signal no_health

@export_category("Statistics")
@export var max_health: float = 40.0
@export var current_health: float = 40.0
@export var max_mana: float = 10.0
@export var current_mana: float = 10.0
@export var attack: int = 5
@export var defense: int = 1
@export var speed:= 100.0

@export_group("Misc")
@export_subgroup("Drops")
@export_enum("Coins","Food","Blood","Pocket Lint") var resource_dropped: Array[String] = []

var player: Player
var attack_ready:= true
var attack_cooldown:= 0.5
var cooldown_timer: Timer

func _ready() -> void:
	no_health.connect(die)
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
		velocity = vector_to.normalized() * speed
		move_and_slide()
		if(attack_ready):
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				if(collision.get_collider() == player):
					player.stats.takeDamage(attack)
					attack_ready = false
					cooldown_timer.start()

func detect_contact():
	return 

func die():
	queue_free()

func takeDamage(amount) -> void:
	current_health -= amount
	if(current_health < 0):
		no_health.emit()
