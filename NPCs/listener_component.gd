@tool
extends Area2D
class_name ListenerComponent

@export var character: Node2D
@export var arrow: AnimatedSprite2D
@export var arrow_offset: Vector2 = Vector2(0, -8)

func _ready():
	if !Engine.is_editor_hint():
		arrow.hide()
	arrow.position = arrow_offset
	Signals.sound_heard.connect(_on_sound_heard)

func _on_sound_heard(context):
	var listener = context["listener"]
	if listener == self:
		arrow.set_frame_and_progress(0, 0)
		arrow.show()
		get_tree().create_timer(3).timeout.connect(arrow.hide)
