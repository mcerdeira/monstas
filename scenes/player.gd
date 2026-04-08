extends Area2D
var speed = 150
var facing = 1
var im_freezed = false

func _ready() -> void:
	Global.player_obj = self
	add_to_group("player")
	
func freeze(val):
	im_freezed = val
	
func _physics_process(delta: float) -> void:
	if !im_freezed:
		player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("left"):
		$sprite.play("default")
		global_position.x -= speed * delta
		facing = -1
		$sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		$sprite.play("default")
		global_position.x += speed * delta
		facing = 1
		$sprite.flip_h = false
		
	if Input.is_action_pressed("down"):
		$sprite.play("down")
		global_position.y += speed * delta
	elif Input.is_action_pressed("up"):
		$sprite.play("up")
		global_position.y -= speed * delta
