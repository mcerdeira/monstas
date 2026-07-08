extends ColorRect
var local_upgrades = []
var upgrades_pos = []
var idx = 0
var confeti_obj = preload("res://scenes/Confeti.tscn")

func _ready() -> void:
	visible = false
	upgrades_pos = [$upgrade1, $upgrade2, $upgrade3]
	
func hide_me():
	$Timer.stop()
	Global.Main.STATE = Global.Main.STATES.NEXT_TURN
	get_tree().paused = false
	visible = false

func show_me():
	$Timer.start()
	idx = 0
	get_tree().paused = true
	visible = true
	local_upgrades = [] + Global.UPGRADES
	randomize()
	local_upgrades.shuffle()
	$upgrade1.animation = local_upgrades[0].id
	$upgrade2.animation = local_upgrades[1].id
	$upgrade3.animation = local_upgrades[2].id
	select_me()
	
func _physics_process(delta: float) -> void:
	if visible:
		var moved = false
		if Input.is_action_just_pressed("leftS"):
			idx -= 1
			moved = true
		elif Input.is_action_just_pressed("rightS"):
			idx += 1
			moved = true
		elif Input.is_action_just_pressed("shoot"):
			#TODO hacer que seleccione el item, quite todo del pool (a menos que sea un re-roll)
			hide_me()
			
		if moved:
			if idx < 0:
				idx = 2
			if idx > 2:
				idx = 0
				
			select_me()
	
func select_me():
	$cosito.global_position.x = upgrades_pos[idx].global_position.x
	$sub.text = local_upgrades[idx].description

func _on_timer_timeout() -> void:
	var r = 5
	for i in range(r):
		var conf = confeti_obj.instantiate()
		conf.global_position = Vector2(randf_range(0, 1152), randf_range(0, 640))
		get_parent().add_child(conf)
