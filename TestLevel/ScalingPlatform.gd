extends MovingPlatform

var timer = 0

func _physics_process(delta: float) -> void:	
	_moving_platform_start()
	timer += .03
	rotate_x(sin(timer) * .02)
	rotate_z(cos(timer) * .02)
	_moving_platform_end()
	pass
