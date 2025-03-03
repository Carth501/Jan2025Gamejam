class_name Enemy extends RigidBody2D

signal no_health
signal dead(enemy_ref)

@export_category("Statistics")
@export var active:= true
@export var max_health: float = 10.0
var current_health: float = 10.0
@export var max_mana: float = 5.0
var current_mana: float = 5.0
@export var attack: int = 1
@export var reach: float = 50.0
@export var defense: int = 1
@export var speed:= 60.0
@export var kb_coeff:= 1.0
@export var kb_duration:= 0.25
var knocked_back:= false
@export var kb_timer: Timer

@export_group("Misc")
@export_subgroup("Drops")
@export_enum("Coins","Food","Blood","Pocket Lint") var resource_dropped: Array[String] = []
@onready var blood_drop_preload = preload("res://scenes/items/blood_drop.tscn")

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

func set_level(value: int):
	# defaults
	max_health = 10.0
	current_health = 10.0
	max_mana = 5.0
	current_mana = 5.0
	attack = 1
	reach = 50.0
	defense = 1
	speed = 60.0
	kb_coeff = 1.0
	kb_duration = 0.25
	max_health += 6 * pow(value/60.0, 2) 
	attack += floori(value/60.0)
	defense += floori(value/60.0)
	speed += value / 2.0

func set_player(new_player: Player):
	player = new_player

func ready_to_attack():
	attack_ready = true

func _process(delta: float) -> void:
	if(!active):
		return
	if(player != null):
		var vector_to = player.position - position
		var desired_velocity = vector_to.normalized() * speed
		var velocity_dif = desired_velocity - linear_velocity
		if(!knocked_back):
			apply_central_force(velocity_dif * 1000 * delta)
		else:
			apply_central_force(velocity_dif * 100 * delta)
		if(attack_ready && (vector_to.length() < reach)):
			player.stats.takeDamage(attack)
			attack_ready = false
			cooldown_timer.start()

func detect_contact():
	return 

func die():
	visible = false
	set_linear_velocity(Vector2.ZERO)
	if(randf() > 0.1):
		var new_drop = blood_drop_preload.instantiate()
		get_tree().root.add_child(new_drop)
		new_drop.position = position
		get_tree().root.move_child(new_drop, 1)
	dead.emit(self)
	active = false
	sleeping = true
	knocked_back = false
	kb_timer.stop()

func takeDamage(amount) -> void:
	if(!active):
		return
	current_health -= maxi(amount - defense, 1)
	if(current_health < 0):
		no_health.emit()

func apply_knockback(vector: Vector2, bonus_duration: float):
	if(!active):
		return
	knocked_back = true
	apply_central_impulse(vector * 5 * kb_coeff)
	kb_timer.wait_time = kb_duration + bonus_duration
	kb_timer.start()

func end_knockback():
	knocked_back = false

func activate():
	active = true
	visible = true
	sleeping = false

func teleport(destination: Vector2):
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(destination)
	)
	set_linear_velocity(Vector2.ZERO)
