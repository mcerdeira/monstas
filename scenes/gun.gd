extends AnimatedSprite2D
var rotate_speed = 1000

func shoot():
	Global.Main.STATE = Global.Main.STATES.SHOOTING
	%monsta_bullet.shoot(%monster_avatar.current_monsta)

func _physics_process(delta: float) -> void:
	rotation_degrees += rotate_speed * delta
	%monster_avatar.rotation_degrees -= rotate_speed * delta
