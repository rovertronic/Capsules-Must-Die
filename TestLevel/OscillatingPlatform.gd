extends MovingPlatform

var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_moving_platform_start()
	rotate_y(.008)
	timer += .02
	position.x += .05 * sin(timer)
	_moving_platform_end()
	pass
