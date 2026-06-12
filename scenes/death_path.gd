extends Node2D
var sleep = 0.0
@onready var spider_path: Line2D = $spiderpath
@onready var path: Path2D = $Path

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
		if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN and sleep <= 0:
			Global.death_bar += Global.DEATH_SPEED * delta
			$Path/follower.progress = Global.death_bar 
			if $Path/follower.progress_ratio >= 1.0:
				Global.Main.STATE = Global.Main.STATES.GAME_OVER
				Global.play_sound(Global.SpiderAddedSFX)
				Global.shaker_obj.shake(5.1, 3.0)
		else:
			if sleep > 0:
				sleep -= 1 * delta
				Global.death_bar -= (Global.DEATH_SPEED - 10) * delta
				$Path/follower.progress = Global.death_bar 
				if sleep <= 0:
					$Path/follower/hitanim.stop()

func reset_bar(count):
	await get_tree().create_timer(0.8).timeout
	$Path/follower/hitanim.play("new_animation")
	sleep = count + 0.1
