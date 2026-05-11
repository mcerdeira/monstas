extends Area2D
var monsta = null
var shooting = false
var speed = 800

func _ready() -> void:
	visible = false
	
func _physics_process(delta: float) -> void:
	if shooting:
		global_position.y -= speed * delta
	
func shoot(_monsta):
	monsta = _monsta
	shooting = true
	visible = true
	
func return_home():
	global_position = get_parent().global_position
	Global.Main.STATE = Global.Main.STATES.COUNTING

func _on_area_entered(area: Area2D) -> void:
	if area and area.is_in_group("gem"):
		shooting = false
		area.hit(monsta)
		visible = false
		return_home()
