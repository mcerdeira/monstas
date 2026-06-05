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
	if !imnext:
		if count > 0:
			$lbl_count.visible = Global.IN_COLLECTION 
			$lbl_count.text =  "x" + str(count)
			
	if !_monsta:
		Global.emit(global_position, 5)
		$monster_avatar.play("empty")
	else:
		Global.emit(global_position, 5)
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
	current_monsta = Global.MONSTA_NEXT.pop_front()
	
	randomize()
	Global.MONSTA_NEXT.append(Global.pick_random(Global.ALL_MONSTAS))
	
	%monsta_next1.set_monsta(Global.MONSTA_NEXT[0])
	%monsta_next2.set_monsta(Global.MONSTA_NEXT[1])
	%monsta_next3.set_monsta(Global.MONSTA_NEXT[2])
	%monsta_next4.set_monsta(Global.MONSTA_NEXT[3])
	%monsta_next5.set_monsta(Global.MONSTA_NEXT[4])
	
	$monster_avatar.play(current_monsta.id)
	
func add_spider():
	var count = Global.PENALTY
	for i in range(5, 0, -1):
		if Global.MONSTA_NEXT[i - 1] != Global.monsta_spider:
			Global.play_sound(Global.SpiderAddedSFX)
			Global.MONSTA_NEXT[i - 1] = Global.monsta_spider
			var node = get_node("%monsta_next" + str(i))
			node.set_monsta(Global.monsta_spider)
			count -= 1
			if count <= 0:
				return  

func _on_click_area_mouse_entered() -> void:
	if !imnext:
		if current_monsta:
			$anim.play("new_animation")
			%Ballon.set_text(current_monsta, global_position)

func _on_click_area_mouse_exited() -> void:
	if !imnext:
		$anim.stop()
		%Ballon.hideme()
