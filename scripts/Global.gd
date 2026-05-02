extends Node
var player_obj = null
var particle = preload("res://scenes/particle2.tscn")
var shaker_obj = null
var FULLSCREEN = false
var UI = null
var Main = null
var SCORE = 0
var MONSTA_NEXT = null
var THIS_TURN_SCORE = 0
var LEVEL = 0
var IN_SHOP = false
var IN_COLLECTION = false
var ALL_MONSTAS = []

var monsta_poop = {
	"id": "poop",
	"name": "Poop",
	"description": "I give 1 point in combo, -1 on falling",
	"points_special": 1,
	"points_falling": -1,
	"special": "row",
}

var monsta_fish = {
	"id": "fish",
	"name": "Fish",
	"description": "I give 1 points in combo, -1 on falling",
	"points_special": 1,
	"points_falling": -1,
	"special": "row",
}

var monsta_zombie = {
	"id": "zombie",
	"name": "Zombie",
	"description":  "I give 3 points in combo, -5 on falling",
	"points_special": 3,
	"points_falling": -5,
	"special": "diagonal",
}

var monsta_vampire = {
	"id": "vampire",
	"name": "Vampire",
	"description": "I give 5 points in combo, 0 on falling",
	"points_special": 5,
	"points_falling": 0,
	"special": "cross",
}

var monsta_cyclops = {
	"id": "cyclops",
	"name": "Cyclops",
	"description":  "I give 2 points in combo, -2 on falling",
	"points_special": 2,
	"points_falling": -2,
	"special": "diagonal",
}

var monsta_spider = {
	"id": "spider",
	"name": "Spider",
	"description": "I ONLY give 5 points on falling.",
	"points_special": 0,
	"points_falling": 5,
	"special": "fall",
}

func init_vars():
	LEVEL = 1
	MONSTA_NEXT = null
	ALL_MONSTAS = [monsta_poop, monsta_fish, monsta_zombie, monsta_vampire, monsta_cyclops, monsta_spider]

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
