extends Node2D
var delay = 0.0
var count_index = 0
var TOTAL_COMBOS = []

var counting_functions = [
	search_rows,
	search_columns,
	search_diagonal_down_right,
	search_diagonal_down_left,
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
		if m == null or m.monsta == null or m.monsta.points_special == 0 or m.monsta.special != special:
			return false
			
		if id == null:
			id = m.monsta.id
		else:
			if id != m.monsta.id:
				return false
			
	return true
	
func search_diagonal_down_right():
	var special = "*"
	for start_x in range(5):
		var combo = []
		var last_monsta = null
		var x = start_x
		var y = 0
		while x < 5 and y < 5:
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo)
				combo = [monsta]
			last_monsta = monsta
			x += 1
			y += 1

		eval_combo(combo)

	for start_y in range(1, 5):
		var combo = []
		var last_monsta = null
		var x = 0
		var y = start_y

		while x < 5 and y < 5:
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo)
				combo = [monsta]
			last_monsta = monsta
			x += 1
			y += 1
			
		eval_combo(combo)
	
func search_diagonal_down_left():
	var special = "*"
	for start_x in range(5):
		var combo = []
		var last_monsta = null
		var x = start_x
		var y = 0

		while x >= 0 and y < 5:
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo)
				combo = [monsta]

			last_monsta = monsta
			x -= 1
			y += 1
			
		eval_combo(combo)

	for start_y in range(1, 5):
		var combo = []
		var last_monsta = null
		var x = 4
		var y = start_y

		while x >= 0 and y < 5:
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo)
				combo = [monsta]

			last_monsta = monsta
			x -= 1
			y += 1

		eval_combo(combo)
	
func bulk_points_turn(monstas):
	for m in monstas:
		m.set_points_turn(m.monsta.points_special)

func _ready() -> void:
	randomize()
	Global.Main = self
	Music.play(Global.MainTheme)
	
func add_spider():
	%monster_avatar.add_spider()
	
	
func search_diagonals():
	pass
	
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
		TOTAL_COMBOS.append(combo)
		
func eval_params():
	if Global.LEVEL == 2:
		Global.DEATH_SPEED += 3
		%shoot_line.set_shoot_speed(0.2)
	elif Global.LEVEL == 3:
		Global.DEATH_SPEED += 3
		%shoot_line.set_shoot_speed(0.2)
	elif Global.LEVEL == 4:
		Global.DEATH_SPEED += 3
		%shoot_line.set_shoot_speed(0.3)
	elif Global.LEVEL == 5:
		Global.DEATH_SPEED += 3
		%shoot_line.set_shoot_speed(0.3)
	elif Global.LEVEL == 6:
		Global.DEATH_SPEED += 3
		%shoot_line.set_shoot_speed(0.4)
	elif Global.LEVEL == 7:
		Global.DEATH_SPEED += 3
		%shoot_line.set_shoot_speed(0.5)
	elif Global.LEVEL == 8:
		Global.DEATH_SPEED += 3
		%shoot_line.set_shoot_speed(0.7)
		
func eval_level():
	if Global.LEVEL > 8:
		Global.LEVEL = int(Global.SCORE / 9900 * 10)
	elif Global.LEVEL == 8 and Global.SCORE >= 9900:
		Global.LEVEL = 9
		level_calc_monstas()
	elif Global.LEVEL == 7 and Global.SCORE >= 7900:
		Global.LEVEL = 8
		level_calc_monstas()
	elif Global.LEVEL == 6 and Global.SCORE >= 6900:
		Global.LEVEL = 7
		level_calc_monstas()
	elif Global.LEVEL == 5 and Global.SCORE >= 5900:
		Global.LEVEL = 6
		level_calc_monstas()
	elif Global.LEVEL == 4 and Global.SCORE >= 4900:
		Global.LEVEL = 5
		level_calc_monstas()
	elif Global.LEVEL == 3 and Global.SCORE >= 3900:
		Global.LEVEL = 4
		level_calc_monstas()
	elif Global.LEVEL == 2 and Global.SCORE >= 2900:
		Global.LEVEL = 3
		level_calc_monstas()
	elif Global.LEVEL == 1 and Global.SCORE >= 900:
		Global.LEVEL = 2
		level_calc_monstas()
	
func level_calc_monstas():
	if Global.LEVEL == 2:
		Global.ALL_MONSTAS.append(Global.FULL_MONSTAS.pop_front())
		Global.ALL_MONSTAS.append(Global.FULL_MONSTAS.pop_front())
	if Global.LEVEL == 4:
		Global.ALL_MONSTAS.append(Global.FULL_MONSTAS.pop_front())
		Global.ALL_MONSTAS.append(Global.FULL_MONSTAS.pop_front())
			
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		Global.play_sound(Global.MonstaJumpSFX)
		get_tree().change_scene_to_file("res://scenes/Title.tscn")
	
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
				if TOTAL_COMBOS.size() > 0:
					var sizes = 0
					var points = 0
					Global.play_sound(Global.ComboSFX)
					for combo in TOTAL_COMBOS:
						sizes += combo.size()
						bulk_points_turn(combo)
	
					%DeathPath.reset_bar(sizes)
					
					eval_level()
					eval_params()
					%UI.show_message("Combo x" + str(sizes), null, false, "(" + str(Global.THIS_TURN_SCORE) + " pts)")
					
				count_index = 0
				STATE = STATES.SHOWING_RESULTS
				$UI/objetive_anim.play("new_animation")
				var monstaslots = get_tree().get_nodes_in_group("monstaslot")
				for monstaslot in monstaslots:
					monstaslot.reset_points_turn(false, true)
					
				TOTAL_COMBOS = []
		else:
			Global.delay_in_count -= 1 * delta
				
	elif STATE == STATES.SHOWING_RESULTS:
		if Global.THIS_TURN_SCORE > 0:
			$UI/objetive_anim.play("new_animation")
			Global.SCORE += 10
			Global.THIS_TURN_SCORE -= 10
			Global.shaker_obj.shake(3.1, 0.2)
		else:
			$UI/objetive_anim.play("new_animation")
			$UI/objetive_anim.stop()
			STATE = STATES.NEXT_TURN
