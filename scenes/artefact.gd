extends Node2D
var animating = false #flag para saber si está rotando el tablero y bloquear acciones
var duration = 0.3
var configuration = 0

func _physics_process(delta: float) -> void:
	$Label.rotation_degrees = -rotation_degrees
	$Label.text = str(rotation_degrees)
	
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		if !%shoot_line.visible:
			%shoot_line.visible = true
			
		if !animating:
			if Input.is_action_just_pressed("shoot"):
				%Gun.shoot()
			if Input.is_action_just_pressed("left"):
				configuration -= 1
				if configuration == -1:
					configuration = 7
				animating = true
				var tween = get_tree().create_tween()
				tween.tween_property(self, "rotation_degrees", rotation_degrees - 45.0, duration)
				tween.tween_callback(_ended)
			elif Input.is_action_just_pressed("right"):
				configuration += 1
				if configuration == 8:
					configuration = 0
				animating = true
				var tween = get_tree().create_tween()
				tween.tween_property(self, "rotation_degrees", rotation_degrees + 45.0, duration)
				tween.tween_callback(_ended)
	else:
		%shoot_line.visible = false

func set_line_point(v: Vector2):
	%shoot_line.set_point_position(1, v)

func _ended():
	animating = false
	if configuration == 0:
		rotation_degrees = 0 #Para seguridad se vuelve a rotación 0
