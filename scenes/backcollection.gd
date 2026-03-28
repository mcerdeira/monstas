extends Node2D
var goto_state = null

func _show():
	get_tree().paused = !get_tree().paused

func show_me(_is_shop = false, _goto_state = null):
	goto_state = _goto_state
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

func _on_btn_close_pressed() -> void:
	hide_me()
	if goto_state != null:
		Global.Main.STATE = goto_state
		goto_state = null
