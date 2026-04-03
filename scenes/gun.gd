extends AnimatedSprite2D
var rotate_speed = 1000

func re_roll():
	%monster_avatar.re_roll()

func shoot():
	$shoot.play("new_animation")
	Global.emit(global_position + Vector2(0, -64), 3)
	Global.shaker_obj.shake(1.1, 0.2)
	Global.Main.STATE = Global.Main.STATES.SHOOTING
	%monsta_bullet.shoot(%monster_avatar.current_monsta)

func _physics_process(delta: float) -> void:
	rotation_degrees += rotate_speed * delta
	%monster_avatar.rotation_degrees -= rotate_speed * delta
