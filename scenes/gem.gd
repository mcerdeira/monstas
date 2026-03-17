extends AnimatedSprite2D
var monsta = null
var temp_monsta = null
var minibullet_obj = load("res://scenes/minibullet.tscn")

func set_monsta_callback():
	var minibullet = minibullet_obj.instantiate()
	minibullet.monsta = monsta
	minibullet.origin = $clickeable
	minibullet.global_position = global_position
	get_parent().get_parent().add_child(minibullet)
	$AnimationPlayer.stop()
	set_monsta(temp_monsta)
	temp_monsta = null
	$monster/stars.visible = false

func set_monsta(_monsta):
	monsta = _monsta
	%monster_temp.animation = monsta.id
	%monster.play(_monsta.id)

func _physics_process(delta: float) -> void:
	rotation_degrees = -get_parent().rotation_degrees

func hit(_monsta):
	if monsta != null:
		%monster_temp.animation = $monster.animation
		$monster/stars.visible = true
		temp_monsta = _monsta
		%monster_temp.animation = temp_monsta.id
		%monster_temp.visible = true
		$AnimationPlayer.play("jump")
	else:
		set_monsta(_monsta)
	
func _on_clickeable_mouse_entered() -> void:
	if monsta:
		%Ballon.set_text(monsta, %monster.global_position)

func _on_clickeable_mouse_exited() -> void:
	%Ballon.hideme()
