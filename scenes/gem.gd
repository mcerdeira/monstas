extends AnimatedSprite2D

func _ready() -> void:
	%monster.play(Global.pick_random(["fish", "poop", "zombie"]))

func _physics_process(delta: float) -> void:
	rotation_degrees = -get_parent().rotation_degrees
