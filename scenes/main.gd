extends Node2D
var delay = 0.0
var count_index = 0
var SHOOT_COUNT = 0
var TOTAL_COMBOS = []
var shoots_no_rainbow = 0

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
		if m == null or m.monsta == null or m.monsta.points_special == 0:
			return false
			
		if id == null:
			id = m.monsta.id
		else:
			if id != m.monsta.id and m.monsta.id != "rainbow" and id != "rainbow":
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
				eval_combo(combo, true, false)
				combo = [monsta]
			last_monsta = monsta
			x += 1
			y += 1

		eval_combo(combo, true, false)

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
				eval_combo(combo, true, false)
				combo = [monsta]
			last_monsta = monsta
			x += 1
			y += 1
			
		eval_combo(combo, true, false)
	
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
				eval_combo(combo, true, false)
				combo = [monsta]

			last_monsta = monsta
			x -= 1
			y += 1
			
		eval_combo(combo, true, false)

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
				eval_combo(combo, true, false)
				combo = [monsta]

			last_monsta = monsta
			x -= 1
			y += 1

		eval_combo(combo, true, false)
	
func bulk_points_turn(monstas, extra = false):
	for m in monstas:
		m.set_points_turn(m.monsta.points_special, extra)

func _ready() -> void:
	SHOOT_COUNT = 0
	randomize()
	Global.Main = self
	Music.play(Global.MainTheme)
	
func search_columns():
	var special = "*"
	var last_monsta = null
	var combo = []
	for x in range(5):
		eval_combo(combo, false, true)
		combo = []
		for y in range(5):
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo, false, true)
				combo = []
				combo.append(monsta)
			last_monsta = monsta
			
	eval_combo(combo, false, true)
	
func search_rows():
	var special = "*"
	var last_monsta = null
	var combo = []
	for y in range(5):
		eval_combo(combo, true, false)
		combo = []
		for x in range(5):
			var monsta = Global.board[x][y]
			if are_equals([last_monsta, monsta], special):
				combo.append(monsta)
			else:
				eval_combo(combo, true, false)
				combo = []
				combo.append(monsta)
			last_monsta = monsta
	
	eval_combo(combo,  true, false)
		
func eval_combo(combo, vertical, horizontal):
	if combo.size() > 2:
		for c in combo:
			c.vertical = vertical
			c.horizontal = horizontal
		
		TOTAL_COMBOS.append(combo)
		
func eval_params():
	if Global.LEVEL == 2:
		Global.DEATH_SPEED += 2
	elif Global.LEVEL == 3:
		Global.DEATH_SPEED += 2
	elif Global.LEVEL == 4:
		Global.DEATH_SPEED += 2
	elif Global.LEVEL == 5:
		Global.DEATH_SPEED += 2
	elif Global.LEVEL == 6:
		Global.DEATH_SPEED += 2
	elif Global.LEVEL == 7:
		Global.DEATH_SPEED += 2
	elif Global.LEVEL == 8:
		Global.DEATH_SPEED += 2
		
func eval_level():
	if Global.LEVEL > 8:
		Global.LEVEL = int(Global.SCORE / 9900 * 10)
	elif Global.LEVEL == 8 and Global.SCORE >= 9900:
		Global.LEVEL = 9
	elif Global.LEVEL == 7 and Global.SCORE >= 7900:
		Global.LEVEL = 8
	elif Global.LEVEL == 6 and Global.SCORE >= 6900:
		Global.LEVEL = 7
	elif Global.LEVEL == 5 and Global.SCORE >= 5900:
		Global.LEVEL = 6
	elif Global.LEVEL == 4 and Global.SCORE >= 4900:
		Global.LEVEL = 5
	elif Global.LEVEL == 3 and Global.SCORE >= 3900:
		Global.LEVEL = 4
	elif Global.LEVEL == 2 and Global.SCORE >= 2900:
		Global.LEVEL = 3
	elif Global.LEVEL == 1 and Global.SCORE >= 900:
		Global.LEVEL = 2
		
func add_monstas():
	if Global.FULL_MONSTAS.size() > 0:
		Global.ALL_MONSTAS.append(Global.FULL_MONSTAS.pop_front())
		
func search_rainbow(combo):
	var count = 0
	for c in combo:
		if c.monsta.id == "rainbow":
			count += 1
			if count >= 3:
				return true
	return false
			
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
					add_monstas()
					var sizes = 0
					var points = 0
					var options = {"pitch_scale": Global.pick_random([1.0, 1.1, 1.2, 1.3])}
					Global.play_sound(Global.ComboSFX, options)
					var super_combo = ""
					for combo in TOTAL_COMBOS:
						sizes += combo.size()
						var rainbow = search_rainbow(combo)
						if rainbow:
							super_combo = "SUPER "
						bulk_points_turn(combo, rainbow)
						
					if sizes >= 5:
						Global.ADD_RAINBOW = true
						shoots_no_rainbow = 0
					else:
						shoots_no_rainbow += 1
						
					if shoots_no_rainbow >= 5:
						if randi() % 4 == 0:
							Global.ADD_RAINBOW = true
							shoots_no_rainbow = 0
						
					%DeathPath.reset_bar(sizes)
					
					%UI.slow_motion()
					
					eval_level()
					eval_params()
				
					%UI.show_message(super_combo + "Combo x" + str(sizes), null, false, "(" + str(Global.THIS_TURN_SCORE) + " pts)")
					
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
			SHOOT_COUNT = 0
			Global.SCORE += 10
			Global.THIS_TURN_SCORE -= 10
			Global.shaker_obj.shake(10.1, 0.2)
		else:
			$UI/objetive_anim.play("new_animation")
			$UI/objetive_anim.stop()
			STATE = STATES.NEXT_TURN
			SHOOT_COUNT += 1
			if SHOOT_COUNT == 5 and !Global.ADD_RAINBOW:
				Global.ADD_SPIDER = true
				SHOOT_COUNT = 0
