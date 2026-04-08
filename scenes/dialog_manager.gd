extends Node2D
var ttl = 0
var current_message = ""
var current_messages = []
var current_message_count = -1
var change_ttl = 0.0

func _ready() -> void:
	visible = false
	
func _physics_process(delta: float) -> void:
	if current_messages.size() > 0:
		if change_ttl > 0:
			change_ttl -= 1 * delta
			if change_ttl <= 0:
				$lbl_text.text = ""
			return
		
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = 0.05
			$lbl_text.text += current_message.substr(0, 1)
			current_message = current_message.substr(1, current_message.length() - 1)
			if !current_message:
				current_message_count += 1
				if current_message_count >= current_messages.size():
					await get_tree().create_timer(1.3).timeout
					visible = false
					Global.player_obj.freeze(false)
				else:
					current_message = current_messages[current_message_count]
					change_ttl = 1.3

func set_text(text : Array):
	visible = true
	current_messages = text
	current_message_count = 0
	current_message = current_messages[current_message_count]
