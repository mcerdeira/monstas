extends Node2D
var poss_idx = 2
var poss = [Vector2(576 - 64 - 64, 584), Vector2(576 - 64, 584), Vector2(576, 584), Vector2(576 + 64, 584), Vector2(576 + 64 + 64, 584)]
var rotate_speed = 1000

func re_roll():
	%monster_avatar.re_roll()
	
func move_left():
	poss_idx -= 1
	if poss_idx < 0:
		poss_idx = 2
	position_me()
	
func move_right():
	poss_idx += 1
	if poss_idx > poss.size()-1:
		poss_idx = 0
	position_me()
	
func position_me():
	global_position = poss[poss_idx]
	
func start_gun():
	$shoot_line/anim.play("new_animation")

func shoot():
	$shoot.play("new_animation")
	Global.emit(global_position + Vector2(0, -64), 3)
	Global.shaker_obj.shake(1.1, 0.2)
	Global.Main.STATE = Global.Main.STATES.SHOOTING
	%monsta_bullet.shoot(%monster_avatar.current_monsta)
	$shoot_line/anim.stop()

func _physics_process(delta: float) -> void:
	$sprite.rotation_degrees += rotate_speed * delta
