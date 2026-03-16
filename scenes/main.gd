extends Node2D

enum STATES 
{
	INIT,
	TRANSITION,
	PLAYER_TURN,
	NEXT_TURN,
	SHOOTING,
	PRE_COUNT,
	COUNTING,
	GAME_OVER
}

var STATE : STATES = STATES.INIT

func _ready() -> void:
	Global.Main = self
	
func set_current_goal():
	if Global.LEVEL == 1:
		Global.GOAL = 10
	
func _physics_process(delta: float) -> void:
	if STATE == STATES.INIT:
		set_current_goal()
		STATE = STATES.TRANSITION
		%monster_avatar.new_turn()
		%UI.show_message("Build Phase", STATES.PLAYER_TURN)
	if STATE == STATES.NEXT_TURN:
		Global.TURN += 1
		if Global.TURN > Global.TOTAL_TURNS:
			Global.TURN = Global.TOTAL_TURNS
			STATE = STATES.TRANSITION
			%monster_avatar.reset_turn()
			%UI.show_message("Scoring Phase", STATES.COUNTING)
		else:
			%monster_avatar.new_turn()
			STATE = STATES.PLAYER_TURN
	if STATE == STATES.COUNTING:
		pass
