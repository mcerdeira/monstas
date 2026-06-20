extends Area2D
var monsta = null
var origin = null
var speed = 1500

func _ready() -> void:
	add_to_group("minubullet")

func _physics_process(delta: float) -> void:
	if monsta:
		global_position.y -= speed * delta
		if global_position.y <= -150:
			if monsta.points_falling !=0:
				Global.ADD_SPIDER = true
				Global.UI.lose_coins(monsta.points_falling)
			queue_free()

func _on_area_entered(area: Area2D) -> void:
	if monsta:
		if area and origin != area and area.is_in_group("gem"):
			area.hit(monsta)
			monsta = null
			queue_free()
