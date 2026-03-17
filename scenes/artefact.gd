extends Node2D
var animating = false #flag para saber si está rotando el tablero y bloquear acciones
var duration = 0.3

func _physics_process(delta: float) -> void:
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		if !%shoot_line.visible:
			%shoot_line.visible = true
			
		if !animating:
			if Input.is_action_just_pressed("shoot"):
				Global.shaker_obj.shake(1.1, 0.5)
				%Gun.shoot()
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
	else:
		%shoot_line.visible = false

func set_line_point(v: Vector2):
	%shoot_line.set_point_position(1, v)

func _ended():
	animating = false
