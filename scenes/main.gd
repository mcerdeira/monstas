extends Node2D
var delay = 0.0
var delay_in_count = 0.0
var count_index = 0

var counting_functions = [
	calc_expiration,
	search_rows,
	search_columns,
	search_cross,
	search_diagonal,
	search_individual,
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
	GAME_OVER
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
	
func initialize_pool():
	var all_copy = [] + Global.MONSTA_ENABLED
	for i in range(Global.TOTAL_TURNS):
		randomize()
		all_copy.shuffle()
		var mon = all_copy.pop_back()
		Global.MONSTA_POOL.append(mon)
	
func set_current_goal():
	$UI/objetive_anim.play("new_animation")
	Global.TURN = 1
	Global.THIS_TURN_COINS = 0
	if Global.LEVEL == 1:
		Global.GOAL = 8
	elif Global.LEVEL == 2:
		Global.GOAL = 25
		
func search_expired():
	var monstaslots = get_tree().get_nodes_in_group("monstaslot")
	for monstaslot in monstaslots:
		if monstaslot.monsta and monstaslot.monsta.expiration == 0:
			monstaslot.expire()
			
func calc_expiration():
	var monstaslots = get_tree().get_nodes_in_group("monstaslot")
	for monstaslot in monstaslots:
		if monstaslot.monsta and monstaslot.monsta.expiration > 0:
			monstaslot.monsta.expiration -= 1
	
	return false
	
func search_individual():
	var retval = false
	var monstaslots = get_tree().get_nodes_in_group("monstaslot")
	for monstaslot in monstaslots:
		if monstaslot.monsta and monstaslot.monsta.points_individual > 0:
			monstaslot.set_points_turn(monstaslot.monsta.points_individual)
			retval = true
			
	return retval
	
func search_rows():
	var retval = false
	var special = "rows"
	if %Artefact.configuration == 0:
		if are_equals([%Gem1, %Gem2, %Gem3], special):
			bulk_points_turn([%Gem1, %Gem2, %Gem3])
		if are_equals([%Gem4, %Gem5, %Gem6], special):
			bulk_points_turn([%Gem4, %Gem5, %Gem6])
		if are_equals([%Gem7, %Gem8, %Gem9], special):
			bulk_points_turn([%Gem7, %Gem8, %Gem9])
			
	elif %Artefact.configuration == 1:
		if are_equals([%Gem4, %Gem2], special):
			bulk_points_turn([%Gem4, %Gem2])
		if are_equals([%Gem7, %Gem5, %Gem3], special):
			bulk_points_turn([%Gem7, %Gem5, %Gem3])
		if are_equals([%Gem8, %Gem6], special):
			bulk_points_turn([%Gem8, %Gem6])
		
	elif %Artefact.configuration == 2:
		if are_equals([%Gem7, %Gem4, %Gem1], special):
			bulk_points_turn([%Gem7, %Gem4, %Gem1])
		if are_equals([%Gem8, %Gem5, %Gem2], special):
			bulk_points_turn([%Gem8, %Gem5, %Gem2])
		if are_equals([%Gem9, %Gem6, %Gem3], special):
			bulk_points_turn([%Gem9, %Gem6, %Gem3])
		
	elif %Artefact.configuration == 3:
		if are_equals([%Gem8, %Gem4], special):
			bulk_points_turn([%Gem8, %Gem4])
		if are_equals([%Gem9, %Gem5, %Gem1], special):
			bulk_points_turn([%Gem9, %Gem5, %Gem1])
		if are_equals([%Gem6, %Gem2], special):
			bulk_points_turn([%Gem6, %Gem2])
		
	elif %Artefact.configuration == 4:
		if are_equals([%Gem9, %Gem8, %Gem7], special):
			bulk_points_turn([%Gem9, %Gem8, %Gem7])
		if are_equals([%Gem6, %Gem5, %Gem4], special):
			bulk_points_turn([%Gem6, %Gem5, %Gem4])
		if are_equals([%Gem3, %Gem2, %Gem1], special):
			bulk_points_turn([%Gem3, %Gem2, %Gem1])
		
	elif %Artefact.configuration == 5:
		if are_equals([%Gem6, %Gem8], special):
			bulk_points_turn([%Gem6, %Gem8])
		if are_equals([%Gem3, %Gem5, %Gem7], special):
			bulk_points_turn([%Gem3, %Gem5, %Gem7])
		if are_equals([%Gem2, %Gem4], special):
			bulk_points_turn([%Gem2, %Gem4])
		
	elif %Artefact.configuration == 6:
		if are_equals([%Gem3, %Gem6, %Gem9], special):
			bulk_points_turn([%Gem3, %Gem6, %Gem9])
		if are_equals([%Gem2, %Gem5, %Gem8], special):
			bulk_points_turn([%Gem2, %Gem5, %Gem8])
		if are_equals([%Gem1, %Gem4, %Gem7], special):
			bulk_points_turn([%Gem1, %Gem4, %Gem7])
		
	elif %Artefact.configuration == 7:
		if are_equals([%Gem2, %Gem6], special):
			bulk_points_turn([%Gem2, %Gem6])
		if are_equals([%Gem1, %Gem5, %Gem9], special):
			bulk_points_turn([%Gem1, %Gem5, %Gem9])
		if are_equals([%Gem4, %Gem8], special):
			bulk_points_turn([%Gem4, %Gem8])
		
	return retval
	
func search_columns():
	var retval = false
	#TODO: implementar
	return retval
	
func search_cross():
	var retval = false
	#TODO: implementar
	return retval
	
func search_diagonal():
	var retval = false
	#TODO: implementar
	return retval
	
func _physics_process(delta: float) -> void:
	if STATE == STATES.INIT:
		count_index = 0
		initialize_pool()
		set_current_goal()
		STATE = STATES.TRANSITION
		%monster_avatar.new_turn()
		%UI.show_message("Build Phase", STATES.PLAYER_TURN)
		var monstaslots = get_tree().get_nodes_in_group("monstaslot")
		for monstaslot in monstaslots:
			monstaslot.reset_points_turn((Global.LEVEL > 1))
		
	elif STATE == STATES.GAME_OVER:
		%UI.show_perma_message("Game Over")
	elif STATE == STATES.NEXT_TURN:
		if delay > 0:
			delay -= 1 * delta
		else:
			var monstaslots = get_tree().get_nodes_in_group("monstaslot")
			for monstaslot in monstaslots:
				if monstaslot.playing_jump_animation:
					#Delay para que termine de animar los saltos antes de contar
					delay = 1.0
					return
					
			Global.TURN += 1
			if Global.TURN > Global.TOTAL_TURNS:
				Global.TURN = Global.TOTAL_TURNS
				STATE = STATES.TRANSITION
				%monster_avatar.reset_turn()
				%UI.show_message("Scoring Phase", STATES.COUNTING)
			else:
				%monster_avatar.new_turn()
				STATE = STATES.PLAYER_TURN
				search_expired()
			
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
				STATE = STATES.SHOWING_RESULTS
				$UI/coins_anim.play("new_animation")
		else:
			delay_in_count -= 1 * delta
				
	elif STATE == STATES.SHOWING_RESULTS:
		if delay_in_count <= 0:
			if Global.THIS_TURN_COINS > 0:
				delay_in_count = 0.1
				Global.COINS += 1
				Global.THIS_TURN_COINS -= 1
			else:
				$UI/coins_anim.stop()
				if Global.COINS >= Global.GOAL:
					Global.LEVEL += 1
					STATE = STATES.INIT
					Global.COINS = Global.COINS - Global.GOAL
				else:
					STATE = STATES.TRANSITION
					%monster_avatar.reset_turn()
					%UI.show_message("Game Over", STATES.GAME_OVER)
		else:
			delay_in_count -= 1 * delta
