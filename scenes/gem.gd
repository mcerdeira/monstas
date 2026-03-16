extends AnimatedSprite2D
var monsta = null

func set_monsta(_monsta):
	monsta = _monsta
	%monster.play(_monsta)

func _physics_process(delta: float) -> void:
	rotation_degrees = -get_parent().rotation_degrees
