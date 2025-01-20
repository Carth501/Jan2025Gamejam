extends Sprite2D

func _physics_process(delta: float) -> void:
	var value = Time.get_ticks_msec() / 500.0
	rotation = sin(value)/4.0
