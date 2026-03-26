extends AnimatedSprite2D
var current_monsta = null

func reset_turn():
	visible = true
	%monsta_bullet.visible = false
	current_monsta = null
	play("empty")
	
func set_monsta(_monsta):
	$lbl_count.visible = Global.IN_COLLECTION 
	current_monsta = _monsta
	play(current_monsta.id)

func new_turn():
	visible = true
	%monsta_bullet.visible = false
	current_monsta = Global.MONSTA_POOL.pop_front()
	play(current_monsta.id)

func _on_click_area_mouse_entered() -> void:
	if current_monsta:
		%Ballon.set_text(current_monsta, global_position)

func _on_click_area_mouse_exited() -> void:
	%Ballon.hideme()
