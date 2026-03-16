extends Area2D

func _ready() -> void:
	add_to_group("gem")

func hit(_monsta):
	get_parent().hit(_monsta)
