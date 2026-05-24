extends AnimatedSprite2D
var monsta = null
var temp_monsta = null #donde guardamos temporalmente el monstruo para el salto
var follower_bullet_obj = load("res://scenes/follower_bullet.tscn")
var monstaeffect_obj = load("res://scenes/monta_effect.tscn")
var minibullet_obj = load("res://scenes/minibullet.tscn") #bala para direccionar el salto
var playing_jump_animation = false #indica si se está reproduciendo la animación de salto
var point_turn = null

func _ready() -> void:
	add_to_group("monstaslot")
	
func reset_points_turn(effects, expire_if = false):
	if effects:
		Global.emit(global_position, 5)
	
	if expire_if and point_turn != null:
		set_monsta(null)
	
	point_turn = null
	
func set_points_turn(points):
	var follower_bullet = follower_bullet_obj.instantiate()
	follower_bullet.global_position = global_position
	get_parent().get_parent().add_child(follower_bullet)
	
	var monstaeffect = monstaeffect_obj.instantiate()
	monstaeffect.global_position = global_position
	monstaeffect.set_sprite(%monster.animation)
	get_parent().get_parent().add_child(monstaeffect)
	
	$Points.play("new_animation")
	Global.emit(global_position, 5)
	Global.THIS_TURN_SCORE += points
	point_turn = points
	
func expire():
	$Points.play("new_animation")
	Global.emit(global_position, 10)
	set_monsta(null)

func set_monsta_callback():
	var minibullet = minibullet_obj.instantiate()
	minibullet.monsta = monsta
	minibullet.origin = $clickeable
	minibullet.global_position = global_position
	get_parent().get_parent().add_child(minibullet)
	$AnimationPlayer.stop()
	playing_jump_animation = false
	set_monsta(temp_monsta)
	%monster_temp.visible = false
	temp_monsta = null
	$monster/stars.visible = false

func set_monsta(_monsta):
	monsta = _monsta
	if monsta == null:
		%monster_temp.animation = "empty"
		%monster.animation = "empty"
	else:
		%monster_temp.animation = monsta.id
		%monster.play(_monsta.id)

func _physics_process(delta: float) -> void:
	rotation_degrees = -get_parent().rotation_degrees

func hit(_monsta):
	var options = {"pitch_scale": Global.get_pitch()}
	Global.play_sound(Global.MonstaJumpSFX, options)
	if monsta != null:
		Global.delay_in_count = 1.1
		Global.shaker_obj.shake(2.0, 1.1)
		Global.emit(global_position, 3)
		%monster_temp.animation = $monster.animation
		$monster/stars.visible = true
		temp_monsta = _monsta
		%monster_temp.animation = temp_monsta.id
		%monster_temp.visible = true
		playing_jump_animation = true
		$AnimationPlayer.play("jump")
	else:
		Global.emit(global_position, 3)
		set_monsta(_monsta)
	
func _on_clickeable_mouse_entered() -> void:
	if monsta:
		$anim.play("new_animation")
		%Ballon.set_text(monsta, %monster.global_position)

func _on_clickeable_mouse_exited() -> void:
	$anim.stop()
	%Ballon.hideme()
