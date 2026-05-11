extends Node2D
var animating = false #flag para saber si está rotando el tablero y bloquear acciones
var duration = 0.1
var configuration = 0

func init_board():
	Global.board = []
	for x in range(5):
		Global.board.append([])
		for y in range(5):
			var index = y * 5 + x + 1
			var cell = get_node("Gem%d" % index)
			Global.board[x].append(cell)

func _ready() -> void:
	var fr = 0
	var gems = get_children()
	for g in gems:
		g.frame = fr
		if fr == 0:
			fr = 1
		else: 
			fr = 0

func _physics_process(delta: float) -> void:
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		if !%shoot_line.visible:
			%shoot_line.visible = true
			%Gun.start_gun()
			
		if !animating:
			if Input.is_action_just_pressed("leftS"):
				%Gun.move_left()
			elif Input.is_action_just_pressed("rightS"):
				%Gun.move_right()
			
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
