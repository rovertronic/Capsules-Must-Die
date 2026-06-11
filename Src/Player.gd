class_name Player
extends PlatformingObject

var Camera : PlayerCamera

var MOVE_SPEED = .08

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	Camera = PlayerCamera.new()
	Camera.Subject = self
	get_tree().current_scene.add_child(Camera)
	Camera.make_current()
	print(Camera)
	print(Camera.get_parent())
	
	print(get_tree().current_scene)
	
	print(Camera is Node)
	print(Camera.get_class())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#Example usage of a player controller, don't actually use this in practice
	
	Velocity.x = 0.0
	Velocity.z = 0.0
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if Input.is_key_pressed(KEY_A):
		Velocity.x += -sin(Camera.Yaw + PI*.5)
		Velocity.z += -cos(Camera.Yaw + PI*.5)
	if Input.is_key_pressed(KEY_D):
		Velocity.x += -sin(Camera.Yaw + PI*-.5)
		Velocity.z += -cos(Camera.Yaw + PI*-.5)
	if Input.is_key_pressed(KEY_W):
		Velocity.x += -sin(Camera.Yaw)
		Velocity.z += -cos(Camera.Yaw)
	if Input.is_key_pressed(KEY_S):
		Velocity.x += sin(Camera.Yaw)
		Velocity.z += cos(Camera.Yaw)
		
	var normalizedVel = Vector2(Velocity.x,Velocity.z).normalized()
	Velocity.x = normalizedVel.x * MOVE_SPEED
	Velocity.z = normalizedVel.y * MOVE_SPEED
		
	if (Velocity.length() > 0.0):
		rotation.y = -atan2(Velocity.z,Velocity.x) - PI*.5
	
	if Input.is_action_just_pressed("ui_accept"):
		Velocity.y = 0.2
		OnFloor = false # Disables floor snap.
	
	super(delta)
	pass
