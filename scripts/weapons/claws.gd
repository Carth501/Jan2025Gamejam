extends Area2D

@export var attack_ready:= true
@export var attack_cooldown:= 0.5
var cooldown_timer: Timer
var damage:= 20.0
var kb_magnitude:= 80
@export var player: Player
@export var shape: CollisionShape2D
var bonus_damage_ready:= false
var bonus_damage_value:= 40
@export var bonus_timer: Timer
@export var sprite: AnimatedSprite2D

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time= attack_cooldown
	cooldown_timer.one_shot= false
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(attack)
	cooldown_timer.start()

func attack():
	sprite.play()
	for node in get_overlapping_bodies():
		if(node.has_method("takeDamage")):
			node.takeDamage(damage)
			var direction= Vector2.RIGHT.rotated(global_rotation)
			node.apply_knockback(direction * kb_magnitude, 0)
			if(player.upgrade_1 && node.current_health <= 0):
				increase_scale()
			if(player.upgrade_2 && bonus_damage_ready):
				node.takeDamage(bonus_damage_value)
			bonus_damage_ready = false
			bonus_timer.start()

func increase_scale():
	var current_size = shape.scale - Vector2(1, 1)
	var increase = Vector2(1,1) / pow(2, current_size.length())
	shape.scale = shape.scale + increase

func _physics_process(delta: float) -> void:
	shape.scale = (shape.scale - Vector2(1, 1)) / pow(2, delta) + Vector2(1, 1)

func ready_bonus():
	bonus_damage_ready = true

func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.frame = 0
