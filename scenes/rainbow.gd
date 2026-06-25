extends Node2D
@export var direction = 1
var speed = 50
var ttl = 2.1

func _physics_process(delta: float) -> void:
	Global.shaker_obj.shake(15.1, 5.2)
	if abs(scale.x) <= 100 :
		scale.x += (speed * direction) * delta
		$killer/collider.scale.x = scale.x 
		speed += 10
	else:
		ttl -= 1 * delta
		if ttl <= 0:
			queue_free()
 
