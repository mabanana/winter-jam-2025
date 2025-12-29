extends Node2D
class_name PlayerController

@export var player_cam: PlayerCamera
@export var aim_line: Line2D
@export var sound_emitter: SoundEmitter
@export_category("Parameters")
@export var SPEED := 50
@export var SCROLL_SENSITIVITY := 0.05
@export var loudness := 100.0

var state: MODES = MODES.IDLE
enum MODES {
	IDLE,
	AIMING,
	SHOOTING,
}

@warning_ignore("unused_parameter")
func _process(delta):
	if state == MODES.AIMING:
		show_aim()
	else:
		aim_line.clear_points()

func _physics_process(delta):
	if state != MODES.IDLE:
		return
	var dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	position += dir * delta * SPEED
	player_cam.position -= dir * delta * SPEED

func _input(event):
	if event.is_action_pressed("aim"):
		change_state(MODES.AIMING)
	elif event.is_action_released("aim"):
		if state == MODES.AIMING:
			change_state(MODES.IDLE)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			player_cam.change_zoom(SCROLL_SENSITIVITY)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			player_cam.change_zoom(-SCROLL_SENSITIVITY)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			start_shot()
	
func change_state(new_state):
	match new_state:
		MODES.AIMING:
			if state != MODES.IDLE:
				return false
			player_cam.change_mode(PlayerCamera.MODES.TARGET_MOUSE_BLENDED)
		MODES.IDLE:
			player_cam.change_mode(PlayerCamera.MODES.TARGET)
		MODES.SHOOTING:
			if state != MODES.AIMING:
				return false
			player_cam.change_mode(PlayerCamera.MODES.TARGET)
		_:
			print("Unknown state code %s, Defaulting to Idle" % [new_state])
			new_state = MODES.IDLE
	
	state = new_state
	print("state change to %s" % [MODES.keys()[new_state]])
	return true


func show_aim():
	var mouse_pos = get_viewport().get_mouse_position()
	var view_rect = get_viewport_rect().size
	var aim_pos = mouse_pos - view_rect / 2
	aim_pos /= player_cam.zoom
	aim_pos += player_cam.position
	aim_line.clear_points()
	aim_line.add_point(Vector2.ZERO)
	aim_line.add_point(aim_pos)

func start_shot():
	if !change_state(MODES.SHOOTING):
		return
	sound_emitter.draw_sound_polygon(loudness)
	get_tree().create_timer(sound_emitter.sound_emission_duration * 2
	).timeout.connect(func():
		change_state(MODES.IDLE)
	)
