extends Control
var goto_state = null
var msg_ttl_total = 2.1
var msg_ttl = 0.0
var start_gun = false

func _ready() -> void:
	Global.UI = self
	
func show_message(message, state, _start_gun = false):
	start_gun = _start_gun
	%lbl_message.visible = true
	%lbl_message.text = message
	goto_state = state
	msg_ttl = msg_ttl_total
	
func lose_coins():
	$objetive_anim.play("new_animation")
	
func emit_from_coins():
	Global.emit($lbl_objetive_point.global_position, 5)
	
func emit_from_objetive():
	Global.emit($lbl_objetive_point.global_position, 5)
	
func show_perma_message(message):
	%lbl_message.visible = true
	%lbl_message.text = message

func _physics_process(delta: float) -> void:
	%lbl_objetive.text = "SCORE: " + str(Global.SCORE)
	if msg_ttl > 0:
		msg_ttl -= 1 * delta
		if msg_ttl <= 0:
			if goto_state != Global.Main.STATES.GAME_OVER:
				%lbl_message.visible = false
			Global.Main.STATE = goto_state
			if start_gun:
				start_gun = false
				%Gun.start_gun()
