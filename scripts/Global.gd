extends Node
var particle = preload("res://scenes/particle2.tscn")
var shaker_obj = null
var FULLSCREEN = false
var Main = null
var COINS = 0
var GOAL = 0
var THIS_TURN_COINS = 0
var LEVEL = 0
var TURN = 1
var PRICE = 0
var IN_SHOP = false
var IN_COLLECTION = false
var TOTAL_TURNS = 5
var MONSTA_ENABLED = []
var ALL_MONSTAS = []
var MONSTA_POOL = []

var monsta_poop = {
	"id": "poop",
	"name": "Poop",
	"description": "I give 1 coin per turn +1 if I'm in a row of poops.",
	"points_individual": 1,
	"points_special": 1,
	"special": "rows",
	"expiration": -1,
}

var monsta_fish = {
	"id": "fish",
	"name": "Fish",
	"description": "I give 2 coins per turns, after 2 turns I'll be gone.",
	"points_individual": 2,
	"points_special": 0,
	"special": "none",
	"expiration": 2,
}

var monsta_zombie = {
	"id": "zombie",
	"name": "Zombie",
	"description": "I give 3 coins per turns, after 1 turns I infect diagonals.",
	"points_individual": 3,
	"points_special": 0,
	"special": "none",
	"expiration": -1,
}

var monsta_vampire = {
	"id": "vampire",
	"name": "Vampire",
	"description": "I give 0 coins. If I'm destroyed by a cross (+) I'll give 10 coins.",
	"points_individual": 0,
	"points_special": 10,
	"special": "rows_other",
	"expiration": -1,
}

var monsta_cyclops = {
	"id": "cyclops",
	"name": "Cyclops",
	"description": "I give 1 coin per turn +1 if I'm in a column of cyclops.",
	"points_individual": 1,
	"points_special": 1,
	"special": "rows",
	"expiration": -1,
}

func init_vars():
	PRICE = 0
	LEVEL = 1
	TURN = 1
	MONSTA_ENABLED = [monsta_poop, monsta_poop, monsta_poop, monsta_poop, monsta_poop]
	ALL_MONSTAS = [monsta_poop, monsta_fish, monsta_zombie, monsta_vampire, monsta_cyclops]

func _ready():
	init_vars()
	
func emit(_global_position, count, particle_obj = null, size = 1):
	var part = particle
	if particle_obj:
		part = particle_obj
	
	for i in range(count):
		var p = part.instantiate()
		p.global_position = _global_position
		p.size = size
		add_child(p)
	
func pick_random(container):
	if typeof(container) == TYPE_DICTIONARY:
		return container.values()[randi() % container.size() ]
	assert( typeof(container) in [
			TYPE_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_INT32_ARRAY,
			TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_STRING_ARRAY,
			TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY
			], "ERROR: pick_random" )
	return container[randi() % container.size()]

func play_sound(stream: AudioStream, options:= {}, _global_position = null, delay = 0.0) -> AudioStreamPlayer:
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS

	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.bus = "SFX"
	
	for prop in options.keys():
		audio_stream_player.set(prop, options[prop])
		
	if delay > 0.0:
		var timer = Timer.new()
		timer.wait_time = delay
		timer.one_shot = true
		timer.connect("timeout", audio_stream_player.play)
		add_child(timer)
		timer.start()
	else:
		audio_stream_player.play()
		
	audio_stream_player.finished.connect(kill.bind(audio_stream_player))
	
	return audio_stream_player
	
func kill(_audio_stream_player):
	if _audio_stream_player and is_instance_valid(_audio_stream_player):
		_audio_stream_player.queue_free()
