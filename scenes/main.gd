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

func _ready() -> void:
	Global.Main = self
	
func set_current_goal():
	Global.THIS_TURN_COINS = 0
	if Global.LEVEL == 1:
		Global.GOAL = 10
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
	#TODO: implementar
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
		set_current_goal()
		STATE = STATES.TRANSITION
		%monster_avatar.new_turn()
		%UI.show_message("Build Phase", STATES.PLAYER_TURN)
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
		else:
			delay_in_count -= 1 * delta
				
	elif STATE == STATES.SHOWING_RESULTS:
		if delay_in_count <= 0:
			if Global.THIS_TURN_COINS > 0:
				delay_in_count = 1.3
				Global.COINS += 1
				Global.THIS_TURN_COINS -= 1
			else:
				if Global.COINS >= Global.GOAL:
					Global.LEVEL += 1
					STATE = STATES.INIT
					Global.COINS = Global.COINS - Global.GOAL
				else:
					STATE = STATES.GAME_OVER
		else:
			delay_in_count -= 1 * delta
