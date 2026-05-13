extends Node2D
var rotate_speed = 1000

func re_roll():
	%monster_avatar.re_roll()
	
func start_gun():
	$shoot_line/anim.play("new_animation")

func shoot():
	$shoot.play("new_animation")
	Global.emit(global_position + Vector2(0, -64), 3)
	Global.shaker_obj.shake(1.1, 0.2)
	Global.Main.STATE = Global.Main.STATES.SHOOTING
	%monsta_bullet.shoot(%monster_avatar.current_monsta)
	$shoot_line/anim.stop()
	%monster_avatar.visible = false

func _physics_process(delta: float) -> void:
	$sprite.rotation_degrees += rotate_speed * delta
