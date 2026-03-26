extends Node2D
	
func _show():
	get_tree().paused = !get_tree().paused

func show_me(_is_shop = false):
	Global.IN_SHOP = _is_shop
	Global.IN_COLLECTION = !_is_shop
	var title = "Collection"
	if Global.IN_SHOP:
		title = "Shop"
	$backcollection/lbl_title.text = title
	$Shop._initialize(Global.IN_SHOP)
	$Collection._initialize(!Global.IN_SHOP)
	
	if round(scale.x) == 0:
		$anim.play("show")

func hide_me():
	Global.IN_COLLECTION = false
	Global.IN_SHOP = false
	$anim.play_backwards("show")

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_action_pressed("click"):
		hide_me()
