extends Node2D

func _physics_process(delta: float) -> void:
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		$sprite.scale.x = Global.death_bar / 100
		Global.death_bar -= 5 * delta
		if Global.death_bar <= 0:
			Global.death_bar = 100
			Global.SPIDERS += 1
