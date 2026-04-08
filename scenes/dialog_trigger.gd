extends Area2D
@export var oneshot = false
@export var DialogMan : Node2D
@export var DialogText: Array[String]
@export var FreezePlayer = true

func _on_area_entered(area: Area2D) -> void:
	if area and area.is_in_group("player"):
		DialogMan.set_text(DialogText)
		if FreezePlayer:
			Global.player_obj.freeze(true)
		if oneshot:
			queue_free()
