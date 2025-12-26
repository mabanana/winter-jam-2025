extends Node2D
class_name PlayerController

@export var aim_line: Line2D
var is_aim: bool = false

func _ready():
	pass

@warning_ignore("unused_parameter")
func _process(delta):
	if is_aim:
		show_aim()
	else:
		aim_line.clear_points()

func _input(event):
	if event.is_action_pressed("aim"):
		start_aim()
	elif event.is_action_released("aim"):
		end_aim()

func start_aim():
	is_aim = true
func end_aim():
	is_aim = false
func show_aim():
	var mouse_pos = get_viewport().get_mouse_position()
	aim_line.clear_points()
	aim_line.add_point(position)
	aim_line.add_point(mouse_pos)
