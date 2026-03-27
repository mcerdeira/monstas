extends Node2D
@export var monsta1 : Node2D = null
@export var monsta2 : Node2D = null
@export var monsta3 : Node2D = null

func _initialize(value):
	if !value:
		visible = false
		monsta1.set_monsta(null)
		monsta2.set_monsta(null)
		monsta3.set_monsta(null)
	else:
		visible = true
		var all_copy = [] + Global.ALL_MONSTAS
		randomize()
		all_copy.shuffle()
		monsta1.set_monsta(all_copy.pop_front())
		all_copy.shuffle()
		monsta2.set_monsta(all_copy.pop_front())
		all_copy.shuffle()
		monsta3.set_monsta(all_copy.pop_front())
