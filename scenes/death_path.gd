extends Node2D

@onready var spider_path: Line2D = $spiderpath
@onready var path: Path2D = $Path

func _ready():
	$Path/follower.progress = Global.death_bar 
	var curve := path.curve
	spider_path.clear_points()
	for point in curve.get_baked_points():
		spider_path.add_point(point)

func _physics_process(delta: float) -> void:
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		Global.death_bar += Global.DEATH_SPEED * delta
		$Path/follower.progress = Global.death_bar 
		if $Path/follower.progress_ratio >= 1.0:
			Global.Main.STATE = Global.Main.STATES.GAME_OVER

func reset_bar(count):
	Global.death_bar -= count * Global.DEATH_SPEED
	$Path/follower.progress = Global.death_bar 
