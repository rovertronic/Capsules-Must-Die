class_name MovingPlatform
extends StaticBody3D

var DeltaTransform : Transform3D
var LastTransform : Transform3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _moving_platform_start() -> void:
	LastTransform = transform
	pass
	
func _moving_platform_end() -> void:
	DeltaTransform = LastTransform.inverse() * transform
	pass
