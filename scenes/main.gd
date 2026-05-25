extends Node2D
var delay = 0.0
var count_index = 0

var counting_functions = [
	search_rows,
	search_columns,
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
}

var STATE : STATES = STATES.INIT

func are_equals(monstas, special):
	var id = null
	for m in monstas:
		if m == null or m.monsta == null or m.monsta.special != special:
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
	
func add_spider():
	%monster_avatar.add_spider()
	
func search_columns():
	var special = "*"
	var last_monsta = null
	var combo = []
	for x in range(5):
		eval_combo(combo)
		combo = []
		for y in range(5):
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo)
				combo = []
				combo.append(monsta)
			last_monsta = monsta
			
	eval_combo(combo)
	
func search_rows():
	var special = "*"
	var last_monsta = null
	var combo = []
	for y in range(5):
		eval_combo(combo)
		combo = []
		for x in range(5):
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo)
				combo = []
				combo.append(monsta)
			last_monsta = monsta
	
	eval_combo(combo)
		
func eval_combo(combo):
	if combo.size() > 2:
		Global.play_sound(Global.ComboSFX)
		%DeathPath.reset_bar(combo.size())
		bulk_points_turn(combo)
		%UI.show_message("Combo x" + str(combo.size()), null, false)
			
func search_cross():
	var retval = false
	var special = "*"
	if are_equals([%Gem2, %Gem5, %Gem8, %Gem4, %Gem6], special):
		bulk_points_turn([%Gem2, %Gem5, %Gem8, %Gem4, %Gem6])
		
	return retval
	
func search_diagonal():
	var retval = false
	var special = "*"

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
		Global.delay_in_count = 0.0
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
		if Global.board == []:
			%Artefact.init_board()
		
		if Global.delay_in_count <= 0:
			if count_index < counting_functions.size():
				Global.delay_in_count = 1.3
				var function = counting_functions[count_index]
				function.call()
				Global.delay_in_count = 0
				count_index += 1
			else:
				count_index = 0
				STATE = STATES.SHOWING_RESULTS
				$UI/objetive_anim.play("new_animation")
				var monstaslots = get_tree().get_nodes_in_group("monstaslot")
				for monstaslot in monstaslots:
					monstaslot.reset_points_turn(false, true)
		else:
			Global.delay_in_count -= 1 * delta
				
	elif STATE == STATES.SHOWING_RESULTS:
		if Global.delay_in_count <= 0:
			if Global.THIS_TURN_SCORE > 0:
				Global.delay_in_count = 0.1
				Global.SCORE += 1
				Global.THIS_TURN_SCORE -= 1
				$UI/objetive_anim.play("new_animation")
				Global.shaker_obj.shake(3.1, 0.2)
			else:
				$UI/objetive_anim.stop()
				STATE = STATES.NEXT_TURN
		else:
			Global.delay_in_count -= 1 * delta
