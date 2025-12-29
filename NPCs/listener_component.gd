@tool
extends Area2D
class_name ListenerComponent

@export var character: Node2D
@export var arrow: Node2D
@export var arrow_offset: Vector2 = Vector2(0, -8)

func _ready():
	if !Engine.is_editor_hint():
		arrow.hide()
	arrow.position = arrow_offset
