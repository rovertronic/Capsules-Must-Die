class_name PlayerCamera
extends Camera3D

var Subject : Node3D

var Yaw = 0.0;
var Pitch = 0.0;
var DampedY = 0.0
var Pan : Vector3

var DIST = 7.0
var SENSITIVITY = .01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("wow.")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	fov = 45.0 * 1.777777777777778
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var pos : Vector3 = Vector3(
		Subject.position.x + sin(Yaw) * cos(Pitch) * DIST,
		DampedY + sin(Pitch) * DIST,
		Subject.position.z + cos(Yaw) * cos(Pitch) * DIST
	)
	var foc : Vector3 = Vector3(
		Subject.position.x + Pan.x,
		DampedY + 1.0,
		Subject.position.z + Pan.z,
	)
	var up : Vector3 = Vector3(
		sin(Pitch) * sin(Yaw) * -1.0,
		cos(Pitch),
		sin(Pitch) * cos(Yaw) * -1.0,
	)

	Pan = Pan.lerp(Subject.basis.z * -1.0, .02)
	DampedY = lerp(DampedY, Subject.position.y,  smoothstep(0.01, 0.9, .04*abs(DampedY - Subject.position.y)) )
	
	position = pos
	look_at(foc)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		Yaw += event.relative.x * SENSITIVITY * -1.0
		Pitch += event.relative.y * SENSITIVITY * .5
		
		Pitch = clamp(Pitch, -PI/2.0 *.9, PI/2.0 *.9)
