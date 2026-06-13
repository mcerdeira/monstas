extends Node2D
var sleep = 0.0
@onready var spider_path: Line2D = $spiderpath
@onready var path: Path2D = $Path

func spawn_splat(left = true):
	for i in 350:
		var dot = ColorRect.new()
		dot.color = Color(0.6, 0, 0)

		var size = randf_range(1, 5)
		dot.size = Vector2(size, size)
		add_child(dot)
		dot.global_position = $Path/heart.global_position
		
		var dir
		if left:
			dir = Vector2.LEFT.rotated(randf_range(-0.8, 0.8))
			dir += Vector2.UP * randf_range(0, 1)
		else:
			dir = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, -0.2)
		).normalized()

		var target = dot.global_position + dir * randf_range(1, 200)

		var tween = create_tween()
		tween.parallel().tween_property(dot, "global_position", target, 0.25)
		tween.parallel().tween_property(dot, "scale", Vector2.ONE * 2.0, 0.25)

func _ready():
	$Path/follower.progress = Global.death_bar 
	var curve := path.curve
	spider_path.clear_points()
	for point in curve.get_baked_points():
		spider_path.add_point(point)

func _physics_process(delta: float) -> void:
	if Global.Main.STATE == Global.Main.STATES.GAME_OVER:
		$Path/follower.progress_ratio = 1.0
	else:
		if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN  and sleep <= 0:
			Global.death_bar += Global.DEATH_SPEED * delta
			$Path/follower.progress = Global.death_bar 
			if $Path/follower.progress_ratio >= 1.0:
				Global.Main.STATE = Global.Main.STATES.GAME_OVER
				Global.play_sound(Global.SpiderHaul)
				Global.shaker_obj.shake(15.1, 5.2)
				spawn_splat()
				await get_tree().create_timer(1.2).timeout
				Global.play_sound(Global.SpiderAddedSFX)
				await get_tree().create_timer(1.2).timeout
				Global.play_sound(Global.Chew)
				spawn_splat(false)
		else:
			if sleep > 0:
				sleep -= 1 * delta
				Global.death_bar -= Global.DEATH_SPEED * delta
				if Global.death_bar <= 50:
					Global.death_bar = 50
					
				$Path/follower.progress = Global.death_bar 
				
				if sleep <= 0:
					$Path/follower/hitanim.stop()

func reset_bar(count):
	await get_tree().create_timer(0.8).timeout
	$Path/follower/hitanim.play("new_animation")
	if count == 3:
		sleep = 2.0
	else:
		sleep = count * 2.0
