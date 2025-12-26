extends Node2D
class_name PlayerController

@export var player_cam: PlayerCamera
@export var aim_line: Line2D
var is_aim: bool = false
var scroll_sensitivity: float = 1

@warning_ignore("unused_parameter")
func _process(delta):
	if is_aim:
		show_aim()
	else:
		aim_line.clear_points()

func _physics_process(delta):
	var dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	position += dir * delta * 300

func _input(event):
	if event.is_action_pressed("aim"):
		start_aim()
	elif event.is_action_released("aim"):
		end_aim()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		player_cam.change_zoom(0.05)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		player_cam.change_zoom(-0.05)

func start_aim():
	is_aim = true
func end_aim():
	is_aim = false
func show_aim():
	var mouse_pos = get_viewport().get_mouse_position()
	var view_rect = get_viewport_rect().size
	var aim_pos = mouse_pos - view_rect / 2
	aim_pos /= player_cam.zoom
	aim_pos += player_cam.position
	aim_line.clear_points()
	aim_line.add_point(Vector2.ZERO)
	aim_line.add_point(aim_pos)
