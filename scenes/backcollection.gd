extends Node2D
var is_shop = false

func _hide():
	visible = false
	
func _show():
	visible = true

func show_me(_is_shop = false):
	if round(scale.x) == 0:
		is_shop = _is_shop
		$anim.play("show")

func hide_me():
	$anim.play_backwards("show")

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_action_pressed("click"):
		hide_me()
