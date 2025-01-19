extends Area2D

@export var attack_ready:= true
@export var attack_cooldown:= 0.5
var cooldown_timer: Timer
var damage:= 20.0

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time= attack_cooldown
	cooldown_timer.one_shot= false
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(attack)
	cooldown_timer.start()

func attack():
	for node in get_overlapping_bodies():
		if(node.has_method("get_stats")):
			node.get_stats().takeDamage(damage)
