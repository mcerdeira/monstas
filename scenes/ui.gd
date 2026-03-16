extends Control
var goto_state = null
var msg_ttl_total = 2.1
var msg_ttl = 0.0

func show_message(message, state):
	%lbl_message.visible = true
	%lbl_message.text = message
	goto_state = state
	msg_ttl = msg_ttl_total

func _physics_process(delta: float) -> void:
	%lbl_objetive.text = "GOAL: " + str(Global.GOAL)
	%lbl_coins.text = "COINS: " + str(Global.COINS)
	%lbl_turns.text = str(Global.TURN) + "/" + str(Global.TOTAL_TURNS)
	if msg_ttl > 0:
		msg_ttl -= 1 * delta
		if msg_ttl <= 0:
			%lbl_message.visible = false
			Global.Main.STATE = goto_state
