class_name Player extends CharacterBody2D

@export var stats: Stats
@export var speed = 400
@export var healthbar:= ProgressBar
@export var weapon: Node
@export var pivot: Node2D 
var inventory:= {}
@export var inventory_panel: InventoryPanel
var active:= true
@export var sprite: AnimatedSprite2D

func get_input():
	if(!active):
		return
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if(input_direction.length() != 0):
		orient(input_direction)
		sprite.animation = "walk"
		if(input_direction.x > 0):
			sprite.set_flip_h(false)
		elif(input_direction.x < 0):
			sprite.set_flip_h(true)
	else:
		sprite.animation = "idle"

func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta: float) -> void:
	healthbar.value = stats.current_health/stats.max_health*100.0

func pickup_item(object):
	if(object.has_method("get_item_id")):
		var item_quantity = inventory.get_or_add(object.get_item_id(), 0)
		item_quantity += object.get_quantity()
		inventory[object.get_item_id()] = item_quantity
		var item_sprite = object.get_sprite()
		var old_transform = item_sprite.global_transform
		object.remove_child(item_sprite)
		add_child(item_sprite)
		object.queue_free()
		item_sprite.global_transform = old_transform
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(item_sprite, "scale", Vector2(0, 0), 1)
		tween.tween_property(item_sprite, "position", Vector2(0, 0), 1)
		tween.finished.connect(item_sprite.queue_free)
		inventory_panel.display_inventory(inventory)

func activate():
	active= true

func deactivate():
	active= false

func orient(move_dir: Vector2):
	pivot.set_rotation(move_dir.angle())
