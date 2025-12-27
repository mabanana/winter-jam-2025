extends Node
class_name SoundEmitter

@export var raycast: RayCast2D
@export var num_rays := 360
@export var bounce_dampen := 5.0
@export var source: Node2D
@export var scene: Node2D
@export var curve: Curve
@export var gradient: Gradient
@export var shader: ShaderMaterial

func _ready():
	scene = source.get_parent()

func draw_sound_polygon(length: float):
	var polygon = Polygon2D.new()
	polygon.color.a = 2
	#get_parent().add_child(polygon)
	polygon.polygon = emit_sound(length)
	polygon.vertex_colors = []
	for i in range(polygon.polygon.size()):
		polygon.vertex_colors.append(Color(0,0,0,1))
	polygon.queue_redraw()

	get_tree().create_timer(2.0).timeout.connect(polygon.queue_free)

# Returns array of positions to draw the sound polygon on screen
func emit_sound(length: float):
	var polygon_array: PackedVector2Array = []
	@warning_ignore("integer_division")
	for ray in range(0, num_rays):
		raycast.position = Vector2.ZERO
		var degrees = 360.0 / num_rays * ray
		var point_array: PackedVector2Array = cast_bouncing_ray(
			Vector2.RIGHT.rotated(deg_to_rad(degrees)), 
			length)
		var line2D = Line2D.new()
		line2D.width_curve = curve
		line2D.gradient = gradient
		line2D.material = shader
		var line_points := point_array
		line_points.insert(0, source.global_position)
		line2D.default_color = Color(1.0, 1.0, 1.0, 0.2)
		line2D.points = line_points
		scene.add_child(line2D)
		get_tree().create_timer(1.5).timeout.connect(line2D.queue_free)
		if point_array:
			polygon_array.append_array(point_array)
	return Geometry2D.convex_hull(polygon_array)

func cast_bouncing_ray(
	direction: Vector2, 
	length: float, 
	collision_points: Array[Vector2] = []
	):
	if length <= 0:
		return collision_points
	
	var collision_point = source.global_position
	if collision_points.size() > 0:
		collision_point = collision_points[-1]
	
	raycast.global_position = collision_point
	raycast.target_position = length * direction
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	if not collider:
		collision_points.append(raycast.target_position + collision_point)
		return collision_points
	# elif collider is a listener
		# 
	else:
		# if collider is wall reflect
		var new_collision_point = raycast.get_collision_point()
		collision_points.append(new_collision_point)
		var normal = raycast.get_collision_normal()
		var distance = (collision_point - new_collision_point).length()
		var new_direction = direction.bounce(normal)
		return cast_bouncing_ray(new_direction, length - distance - bounce_dampen, collision_points)
	
