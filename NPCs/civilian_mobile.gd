extends Node2D

@export var pathFollow2D: NpcPath
@export var sprite2D: Sprite2D

var speed = 30
var last_position = Vector2(0,0)
var is_waiting = false

func _process(delta: float) -> void:
	# walks to waypoints
	if is_waiting:
		pass
	var progress = pathFollow2D.get_progress()
	pathFollow2D.set_progress(progress + speed * delta)
	handle_change_direction()
	if abs(progress - get_closest_wait_point()) < 0.1:
		is_waiting = true
		get_tree().create_timer(5).timeout.connect(func():
			is_waiting = false)

func handle_change_direction() -> void:
	var current_position = global_position
	if current_position.x < last_position.x:
		sprite2D.flip_h = true
	else:
		sprite2D.flip_h = false
	last_position = current_position

func get_closest_wait_point() -> float:
	var closest_value = 2 # 1 is max distance
	var current_progress_ratio = pathFollow2D.get_progress_ratio()
	for i in range(len(pathFollow2D.points)):
		var distance = abs(current_progress_ratio - pathFollow2D.points[i])
		if distance < closest_value:
			closest_value = distance
	return closest_value
