extends Node2D

func _on_control_gui_input(event: InputEvent) -> void:
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		if event is InputEventMouseButton && event.is_action_pressed("click"):
			show_shop(false)

func show_shop(shop = false):
	%backcollection.show_me(shop)

func _on_control_mouse_entered() -> void:
	$anim.play("new_animation")

func _on_control_mouse_exited() -> void:
	$anim.stop()
