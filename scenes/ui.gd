extends Control
var goto_state = null
var msg_ttl_total = 2.1
var msg_ttl = 0.0

func show_message(message, state):
	%lbl_message.visible = true
	%lbl_message.text = message
	goto_state = state
	msg_ttl = msg_ttl_total
	
func turn_change():
	$lbl_turns/anim.play("new_animation")
	Global.emit($lbl_turns/smoke_mark.global_position, 10)
	
func emit_from_coins():
	Global.emit($lbl_coins_point.global_position, 5)
	
func emit_from_objetive():
	Global.emit($lbl_objetive_point.global_position, 5)
	
func show_perma_message(message):
	%lbl_message.visible = true
	%lbl_message.text = message

func _physics_process(delta: float) -> void:
	%lbl_objetive.text = "GOAL: " + str(Global.GOAL)
	%lbl_coins.text = "COINS: " + str(Global.COINS)
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN or Global.Main.STATE == Global.Main.STATES.SHOOTING:
		%lbl_turns.text = str(Global.TURN) + "/" + str(Global.TOTAL_TURNS)
	else:
		%lbl_turns.text = "-/-"
	if msg_ttl > 0:
		msg_ttl -= 1 * delta
		if msg_ttl <= 0:
			if goto_state != Global.Main.STATES.GAME_OVER:
				turn_change()
				%lbl_message.visible = false
			Global.Main.STATE = goto_state
