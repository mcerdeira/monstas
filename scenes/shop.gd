extends Node2D
@export var monsta1 : Node2D = null
@export var monsta2 : Node2D = null
@export var monsta3 : Node2D = null

func _ready() -> void:
	monsta1.set_monsta(Global.ALL_MONSTAS[0])
	monsta2.set_monsta(Global.ALL_MONSTAS[1])
