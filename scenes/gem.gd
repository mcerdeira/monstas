extends AnimatedSprite2D
var monsta = null

func set_monsta(_monsta):
	monsta = _monsta
	%monster.play(_monsta.id)

func _physics_process(delta: float) -> void:
	rotation_degrees = -get_parent().rotation_degrees

func hit(_monsta):
	if monsta == null:
		set_monsta(_monsta)

func _on_clickeable_mouse_entered() -> void:
	if monsta:
		%Ballon.set_text(monsta, %monster.global_position)

func _on_clickeable_mouse_exited() -> void:
	%Ballon.hideme()
