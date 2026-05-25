extends PathFollow2D

func _ready() -> void:
	Global.spider_follower = self

func _physics_process(delta: float) -> void:
	if %DeathPath.sleep > 0:
		$spider/stars.visible = true
	else:
		$spider/stars.visible = false
