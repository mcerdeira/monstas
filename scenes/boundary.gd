extends Area2D
var ttl = 1.0

func set_on():
	$collider.set_deferred("disabled", false)

func _physics_process(delta: float) -> void:
	ttl -= 1 * delta
	if ttl <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area and area.is_in_group("gem"):
		if area.get_parent().monsta:
			if area.get_parent().monsta.id == "spider":
				area.get_parent().kill_spider()
