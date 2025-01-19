class_name Player extends CharacterBody2D

@export var stats: Stats
@export var speed = 400
@export var healthbar:= ProgressBar

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta: float) -> void:
	healthbar.value = stats.current_health/stats.max_health*100.0
