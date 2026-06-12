class_name PlatformingObject
extends Node3D

# Higher iterations = More precise collision at higher speeds, but uses more performance
@export var Iterations : int = 4
@export var Radius : float = .5
@export var DebugGroundingDot : Node3D

var FLOOR_SNAP_THRESHOLD = 0.2 #Set this to your project's maximum stair height

var StepDelta : float = 1.0 / Iterations
var Velocity : Vector3
var OnFloor : bool = false

# Unpleasant solution, but unfortunately platforms tilting on X and Z don't play well with footing outside origin.
func platform_is_strange(platform : Node3D) -> bool:
	return (platform is MovingPlatform and ((abs(platform.rotation.x) > 0.0) or (abs(platform.rotation.z) > 0.0))  )

func handle_floor_collision(iteration : int) -> void:
	var space_state = get_world_3d().get_direct_space_state()
	
	var shape = PhysicsServer3D.cylinder_shape_create()
	PhysicsServer3D.shape_set_data(shape, {"radius" : Radius - .01, "height" : 2.0})
	
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape_rid = shape
	query.transform = Transform3D(
		Basis.IDENTITY,
		position + Vector3(0.0,0.5,0.0)
	)
	
	var points : Array[Vector3] = space_state.collide_shape(query)
	points.append(position)
	
	var samples : Array[Vector3]
	var platforms : Array[Node3D]
	
	for point in points:
		var toOffset = - 0.5
		if point == position:
			toOffset = - 1.0
		
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = Vector3(point.x,position.y + 1.0,point.z)
		rayQuery.to = Vector3(point.x,position.y + toOffset,point.z)
		
		var result = space_state.intersect_ray(rayQuery)
		if result and !(point != position and platform_is_strange(result["collider"])):
			samples.append(result["position"])
			platforms.append(result["collider"])
		
	if samples.size() > 0:
		var closest_sample : Vector3
		var closest_dist = 999999999.0
		for sample in samples:
			var lat_dist_squared = pow(sample.x - position.x,2.0) + pow(sample.z - position.z,2.0)
			if lat_dist_squared < closest_dist:
				closest_dist = lat_dist_squared
				closest_sample = sample
				
		var compareY = position.y
		if OnFloor:
			compareY = position.y - FLOOR_SNAP_THRESHOLD
				
		if closest_sample.y > compareY:
			Velocity.y = 0
			position.y = closest_sample.y
			
			if iteration == 3 and platforms[0] is MovingPlatform:
				var delta_transform = platforms[0].DeltaTransform
				var player_relative = platforms[0].transform.inverse() * transform
				position = (platforms[0].transform * delta_transform * player_relative).origin

			OnFloor = true
			
			if DebugGroundingDot:
				DebugGroundingDot.global_position = closest_sample
	else:
		OnFloor = false
	
	PhysicsServer3D.free_rid(shape)

func handle_wall_collision() -> void:
	var space_state = get_world_3d().get_direct_space_state()
	
	var shape = PhysicsServer3D.cylinder_shape_create()
	PhysicsServer3D.shape_set_data(shape, {"radius" : Radius, "height" : 1.0})
	
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape_rid = shape
	query.transform = Transform3D(
		Basis.IDENTITY,
		position + Vector3(0.0,1.5,0.0)
	)
	
	var rest_info = space_state.get_rest_info(query)
	
	if rest_info:
		var push = Radius - (position * Vector3(1,0,1)).distance_to(rest_info["point"] * Vector3(1,0,1))
		position += rest_info["normal"] * Vector3(1,0,1) * push
	
	PhysicsServer3D.free_rid(shape)

func _physics_process(delta: float) -> void:	
	Velocity.y -= .005
	
	for i in range(Iterations):
		position += Velocity * StepDelta
		handle_floor_collision(i)
		handle_wall_collision()
	
	pass
