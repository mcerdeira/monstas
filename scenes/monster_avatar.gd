extends AnimatedSprite2D
var current_monsta = null

func reset_turn():
	visible = true
	%monsta_bullet.visible = false
	current_monsta = null
	play("empty")
	
func set_monsta(_monsta, count = 0):
	current_monsta = _monsta
	$btn_buy.visible = false
	if count > 0:
		$lbl_count.visible = Global.IN_COLLECTION 
		$lbl_count.text =  "x" + str(count)
		
	if Global.IN_SHOP:
		$btn_buy.disabled = false
		if current_monsta:
			if Global.PRICE == 0:
				$btn_buy.text = "Free!"
			else:
				$btn_buy.text = "Buy $" + str(Global.PRICE)
		$btn_buy.visible = true
		
	if !_monsta:
		play("empty")
	else:
		play(current_monsta.id)

func new_turn():
	visible = true
	%monsta_bullet.visible = false
	current_monsta = Global.MONSTA_POOL.pop_front()
	play(current_monsta.id)

func _on_click_area_mouse_entered() -> void:
	if current_monsta:
		$anim.play("new_animation")
		%Ballon.set_text(current_monsta, global_position)

func _on_click_area_mouse_exited() -> void:
	$anim.stop()
	%Ballon.hideme()

func _on_btn_buy_pressed() -> void:
	if Global.PRICE <= Global.COINS:
		Global.COINS -= Global.PRICE
		Global.MONSTA_ENABLED.append(current_monsta)
		$btn_buy.text = "OWNED"
		$btn_buy.disabled = true
