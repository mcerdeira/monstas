extends Node2D
var animating = false
var duration = 0.3

func _physics_process(delta: float) -> void:
	if !animating:
		if Input.is_action_just_pressed("left"):
			animating = true
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation_degrees", rotation_degrees - 45, duration)
			tween.tween_callback(_ended)
		elif Input.is_action_just_pressed("right"):
			animating = true
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation_degrees", rotation_degrees + 45, duration)
			tween.tween_callback(_ended)

func set_line_point(v: Vector2):
	%shoot_line.set_point_position(1, v)

func _ended():
	animating = false
