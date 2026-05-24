extends Node2D
@export var speed := 500.0

func _ready() -> void:
	speed += Global.pick_random([500, 600, 800])

func _physics_process(delta: float) -> void:
	var target = Global.spider_follower
	var dir = global_position.direction_to(target.global_position)
	
	Global.emit(global_position, 1)
	
	speed += 10 * delta
	rotation = dir.angle() + PI / 2
	global_position += dir * speed * delta

	if global_position.distance_to(target.global_position) < 8:
		Global.emit(global_position, 10)
		queue_free()
