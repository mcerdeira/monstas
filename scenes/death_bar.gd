extends Node2D

func _physics_process(delta: float) -> void:
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		$sprite.scale.x = Global.death_bar / 100
		Global.death_bar -= 5 * delta
		if Global.death_bar <= 0:
			reset_bar(true)
			
func reset_bar(bad = false):
	if bad:
		Global.Main.add_spider()
	Global.death_bar = 100
	Global.emit(global_position, 5)
	Global.emit($sprite.global_position, 5)
	Global.emit($spider.global_position, 5)
	$anim.play("new_animation")
