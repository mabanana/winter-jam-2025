extends Node
class_name SoundEmitter

@export var raycast: RayCast2D
@export var num_rays := 360

# Returns array of positions to draw the sound polygon on screen
func emit_sound(length: float):
	var polygon_array := []
	for degrees in range(1, 1 + num_rays):
		var point = cast_bouncing_ray(Vector2.RIGHT.rotated(deg_to_rad(degrees)), length)
		if point:
			polygon_array.append(point)
	return polygon_array

func cast_bouncing_ray(
	direction: Vector2, 
	length: float, 
	collision_point: Vector2 = Vector2.ZERO
	):
	if length <= 0:
		return collision_point
	
	raycast.position = collision_point
	raycast.target_position = length * direction + collision_point
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	if not collider:
		return raycast.target_position
	# elif collider is a listener
		# 
	else:
		# if collider is wall reflect
		var normal = raycast.get_collision_normal()
		var new_collision_point = raycast.get_collision_point()
		
		var distance = (collision_point - new_collision_point).length()
		var new_direction = direction.bounce(normal)
		
		return cast_bouncing_ray(new_direction, length - distance, new_collision_point)
	
