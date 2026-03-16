extends Node2D

func set_text(_monsta, pos):
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN:
		global_position = pos
		visible = true
		$PanelContainer/MarginContainer/lbl_dialog.text = _monsta.name + ": " + _monsta.description

func hideme():
	$PanelContainer/MarginContainer/lbl_dialog.text = ""
	visible = false
