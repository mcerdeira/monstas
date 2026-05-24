extends Node2D

@export var jump_distance := 80.0
@export var jump_height := 40.0
@export var duration := 0.45

@export var pop_scale := 1.25
@export var max_rotation := 35.0

var start_pos: Vector2
var target_pos: Vector2

func _ready():
	randomize()
	Global.emit(global_position, 10)

	start_pos = global_position

	# Izquierda o derecha random
	var dir = [-1, 1].pick_random()

	target_pos = start_pos + Vector2(jump_distance * dir, 300)

	do_jump()

func set_sprite(anim):
	$monster.animation = anim

func do_jump():
	# Tween principal
	var tween = create_tween()
	tween.set_parallel(true)

	# POP hacia cámara
	tween.tween_property(
		self,
		"scale",
		Vector2(pop_scale, pop_scale),
		0.08
	).set_trans(Tween.TRANS_BACK)

	tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		duration
	)
	
	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		duration
	)

	# Rotación random
	tween.tween_property(
		self,
		"rotation_degrees",
		randf_range(-max_rotation, max_rotation),
		duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# Movimiento parabólico manual
	var jump_tween = create_tween()

	var steps := 24

	for i in range(steps):
		var t = float(i + 1) / steps

		jump_tween.tween_callback(func():
			var x = lerp(start_pos.x, target_pos.x, t)

			# Parábola
			var y = start_pos.y - sin(t * PI) * jump_height

			global_position = Vector2(x, y)
		)

		jump_tween.tween_interval(duration / steps)
