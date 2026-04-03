extends Node2D
var dead = false
@export var Gun : Node2D

func _on_control_gui_input(event: InputEvent) -> void:
	if Global.Main.STATE == Global.Main.STATES.PLAYER_TURN and !dead:
		if event is InputEventMouseButton && event.is_action_pressed("click"):
			dead = true
			Global.emit(global_position, 15)
			$sprite.animation = "dead"
			Gun.re_roll()
			mouse_out()

func _on_control_mouse_entered() -> void:
	if !dead:
		$anim.play("new_animation")
		$AnimatedSprite2D.visible = true
		$PanelContainer.visible = true
	
func _on_control_mouse_exited() -> void:
	if !dead:
		mouse_out()

func mouse_out():
	$anim.stop()
	$AnimatedSprite2D.visible = false
	$PanelContainer.visible = false
