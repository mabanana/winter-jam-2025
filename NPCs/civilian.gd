extends Node2D

@export var pathFollow2D: PathFollow2D

var speed = 30
# walks to waypoint
func _process(delta: float) -> void:
	var progress = pathFollow2D.get_progress()
	pathFollow2D.set_progress(progress + speed * delta)
