extends Node2D
var delay = 0.0
var delay_in_count = 0.0
var count_index = 0

var counting_functions = [
	search_rows,
	search_cross,
	search_diagonal,
]

enum STATES 
{
	INIT,
	TRANSITION,
	PLAYER_TURN,
	NEXT_TURN,
	SHOOTING,
	PRE_COUNT,
	COUNTING,
	SHOWING_RESULTS,
	GAME_OVER,
	SHOP
}

var STATE : STATES = STATES.INIT

func are_equals(monstas, special):
	var id = null
	for m in monstas:
		if m.monsta == null or  m.monsta.special != special:
			return false
			
		if id == null:
			id = m.monsta.id
		else:
			if id != m.monsta.id:
				return false
			
	return true
	
func bulk_points_turn(monstas):
	for m in monstas:
		m.set_points_turn(m.monsta.points_special)

func _ready() -> void:
	randomize()
	Global.Main = self
	
func search_rows():
	var retval = false
	var special = "row"

	if are_equals([%Gem1, %Gem2, %Gem3], special):
		bulk_points_turn([%Gem1, %Gem2, %Gem3])
	if are_equals([%Gem4, %Gem5, %Gem6], special):
		bulk_points_turn([%Gem4, %Gem5, %Gem6])
	if are_equals([%Gem7, %Gem8, %Gem9], special):
		bulk_points_turn([%Gem7, %Gem8, %Gem9])
		
	if are_equals([%Gem7, %Gem4, %Gem1], special):
		bulk_points_turn([%Gem7, %Gem4, %Gem1])
	if are_equals([%Gem8, %Gem5, %Gem2], special):
		bulk_points_turn([%Gem8, %Gem5, %Gem2])
	if are_equals([%Gem9, %Gem6, %Gem3], special):
		bulk_points_turn([%Gem9, %Gem6, %Gem3])

	if are_equals([%Gem9, %Gem8, %Gem7], special):
		bulk_points_turn([%Gem9, %Gem8, %Gem7])
	if are_equals([%Gem6, %Gem5, %Gem4], special):
		bulk_points_turn([%Gem6, %Gem5, %Gem4])
	if are_equals([%Gem3, %Gem2, %Gem1], special):
		bulk_points_turn([%Gem3, %Gem2, %Gem1])

	if are_equals([%Gem3, %Gem6, %Gem9], special):
		bulk_points_turn([%Gem3, %Gem6, %Gem9])
	if are_equals([%Gem2, %Gem5, %Gem8], special):
		bulk_points_turn([%Gem2, %Gem5, %Gem8])
	if are_equals([%Gem1, %Gem4, %Gem7], special):
		bulk_points_turn([%Gem1, %Gem4, %Gem7])
		
	return retval
	
func search_cross():
	var retval = false
	var special = "cross"
	if are_equals([%Gem2, %Gem5, %Gem8, %Gem4, %Gem6], special):
		bulk_points_turn([%Gem2, %Gem5, %Gem8, %Gem4, %Gem6])
		
	return retval
	
func search_diagonal():
	var retval = false
	var special = "diagonal"

	if are_equals([%Gem7, %Gem5, %Gem3], special):
		bulk_points_turn([%Gem7, %Gem5, %Gem3])
	if are_equals([%Gem1, %Gem5, %Gem9], special):
		bulk_points_turn([%Gem1, %Gem5, %Gem9])

	return retval
	
func _physics_process(delta: float) -> void:
	if STATE == STATES.INIT:
		count_index = 0
		STATE = STATES.TRANSITION
		%monster_avatar.new_turn()
		%UI.show_message("Ready?", STATES.PLAYER_TURN, true)
		var monstaslots = get_tree().get_nodes_in_group("monstaslot")
		for monstaslot in monstaslots:
			monstaslot.reset_points_turn(false)
		
	elif STATE == STATES.GAME_OVER:
		%UI.show_perma_message("Game Over")
	elif STATE == STATES.NEXT_TURN:
		delay_in_count = 0.3
		if delay > 0:
			delay -= 1 * delta
		else:
			var monstaslots = get_tree().get_nodes_in_group("monstaslot")
			for monstaslot in monstaslots:
				if monstaslot.playing_jump_animation:
					#Delay para que termine de animar los saltos antes de contar
					delay = 1.0
					return
					
			%monster_avatar.new_turn()
			STATE = STATES.PLAYER_TURN
			
	elif STATE == STATES.COUNTING:
		if delay_in_count <= 0:
			if count_index < counting_functions.size():
				delay_in_count = 1.3
				var function = counting_functions[count_index]
				var result = function.call()
				if !result:
					delay_in_count = 0
				count_index += 1
			else:
				count_index = 0
				STATE = STATES.SHOWING_RESULTS
				$UI/objetive_anim.play("new_animation")
				var monstaslots = get_tree().get_nodes_in_group("monstaslot")
				for monstaslot in monstaslots:
					monstaslot.reset_points_turn(false, true)
		else:
			delay_in_count -= 1 * delta
				
	elif STATE == STATES.SHOWING_RESULTS:
		if delay_in_count <= 0:
			if Global.THIS_TURN_SCORE > 0:
				delay_in_count = 0.1
				Global.SCORE += 1
				Global.THIS_TURN_SCORE -= 1
			else:
				$UI/objetive_anim.stop()
				STATE = STATES.NEXT_TURN
		else:
			delay_in_count -= 1 * delta
