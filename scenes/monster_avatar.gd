extends AnimatedSprite2D
var current_monsta = null

func reset_turn():
	visible = true
	%monsta_bullet.visible = false
	current_monsta = null
	play("empty")

func new_turn():
	visible = true
	%monsta_bullet.visible = false
	current_monsta = Global.pick_random(Global.MONSTA_ENABLED)
	play(current_monsta.id)

func _on_click_area_mouse_entered() -> void:
	if current_monsta:
		%Ballon.set_text(current_monsta, get_parent().global_position)

func _on_click_area_mouse_exited() -> void:
	%Ballon.hideme()
