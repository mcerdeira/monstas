extends Node2D

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_action_pressed("click"):
		%backcollection.visible = true
