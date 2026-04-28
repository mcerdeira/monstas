extends Node2D
var current_monsta = null
@export var imnext = false

func reset_turn():
	Global.emit(global_position, 5)
	visible = true
	%monsta_bullet.visible = false
	current_monsta = null
	$monster_avatar.play("empty")
	
func set_monsta(_monsta, count = 0):
	current_monsta = _monsta
	$btn_buy.visible = false
	if !imnext:
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
		$monster_avatar.play("empty")
	else:
		$monster_avatar.play(current_monsta.id)
		
func re_roll():
	Global.emit(global_position, 5)
	visible = true
	%monsta_bullet.visible = false
	var enabled = [] + Global.ALL_MONSTAS
	enabled.shuffle()
	current_monsta = enabled.pop_at(0)
	$monster_avatar.play(current_monsta.id)

func new_turn():
	Global.emit(global_position, 5)
	visible = true
	%monsta_bullet.visible = false
	var mons = [] + Global.ALL_MONSTAS
	mons.shuffle()
	current_monsta = mons.pop_front()
	%monsta_next.set_monsta(mons[0])
	$monster_avatar.play(current_monsta.id)

func _on_click_area_mouse_entered() -> void:
	if !imnext:
		if current_monsta:
			$anim.play("new_animation")
			%Ballon.set_text(current_monsta, global_position)

func _on_click_area_mouse_exited() -> void:
	if !imnext:
		$anim.stop()
		%Ballon.hideme()
