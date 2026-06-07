extends Node2D
var monstaeffect_obj = load("res://scenes/monta_effect.tscn")
var ttl = 1.0
var ttl_start = 2.1
var start_pressed = false

func _ready() -> void:
	Music.play(Global.TitleTheme)

func _physics_process(delta: float) -> void:
	if !start_pressed:
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
		if Input.is_action_just_pressed("enter"):
			Global.play_sound(Global.SpiderAddedSFX)
			start_pressed = true
			$lbl_title/AnimationPlayer.speed_scale = 5.0
	else:
		ttl_start -= 1 * delta
		if ttl_start <= 0:
			Global.init_vars()
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		
	ttl -= 1 * delta
	if ttl <= 0:
		ttl = 1.1
		for i in range(Global.pick_random([10, 20, 30])):
			var viewport_size = get_viewport_rect().size
			var random_pos = Vector2(
				randf_range(0, viewport_size.x),
				randf_range(0, viewport_size.y)
			)
			var monstaeffect = monstaeffect_obj.instantiate()
			monstaeffect.global_position = random_pos
			monstaeffect.set_sprite_random()
			add_child(monstaeffect)
		
