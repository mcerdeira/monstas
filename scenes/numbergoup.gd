extends Node2D
var points = 0

func _physics_process(delta: float) -> void:
	$lbl_points.text = str(points)

func _kill_me():
	queue_free()
