extends AnimatedSprite2D
var rotate_speed = 1000

func _physics_process(delta: float) -> void:
	rotation_degrees += rotate_speed * delta
	%monster.rotation_degrees -= rotate_speed * delta
