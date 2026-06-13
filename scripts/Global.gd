extends Node
var SpiderHaul = null
var Chew = null
var SpiderAddedSFX = null
var GunMoveSFX = null
var MonstaJumpSFX = null
var ShootSFX = null
var ComboSFX = null
var TitleTheme = null
var MainTheme = null
var player_obj = null
var particle = preload("res://scenes/particle2.tscn")
var shaker_obj = null
var FULLSCREEN = false
var PENALTY = 0
var DEATH_SPEED = 0
var GAME_OVER = false
var UI = null
var pitch_max = 1.2
var pitch_min = 0.4
var pitch = pitch_min
var Main = null
var SCORE = 0
var MONSTA_NEXT = []
var THIS_TURN_SCORE = 0
var LEVEL = 0
var FULL_MONSTAS = []
var ALL_MONSTAS = []
var SPIDERS = 0
var delay_in_count = 0.0
var board = []
var death_bar = 80.0
var spider_follower = null

var monsta_poop = {
	"id": "poop",
	"name": "Poop",
	"description": "FFFFFFFFARRRTTTTT",
	"points_special": 100,
	"points_falling": -100,
	"special": "*",
}

var monsta_fish = {
	"id": "fish",
	"name": "Fish",
	"description": "GLUBBBB GLULBUBLUBLUB",
	"points_special": 100,
	"points_falling": -100,
	"special": "*",
}

var monsta_zombie = {
	"id": "zombie",
	"name": "Zombie",
	"description":  "BRRRRAAAINNNSSSSSS",
	"points_special": 100,
	"points_falling": -100,
	"special": "*",
}

var monsta_tentacles = {
	"id": "tentacles",
	"name": "Tentacles",
	"description": "BORRRRRRRRRR",
	"points_special": 100,
	"points_falling": -100,
	"special": "*",
}

var monsta_vampire = {
	"id": "vampire",
	"name": "Vampire",
	"description": "KII KII KII KII",
	"points_special": 100,
	"points_falling": -100,
	"special": "*",
}

var monsta_cyclops = {
	"id": "cyclops",
	"name": "Cyclops",
	"description":  "SLURPPPPPP",
	"points_special": 100,
	"points_falling": -100,
	"special": "*",
}

var monsta_slime = {
	"id": "slime",
	"name": "Slime",
	"description":  "NORRRPO",
	"points_special": 100,
	"points_falling": -100,
	"special": "*",
}

var monsta_spider = {
	"id": "spider",
	"name": "Spider",
	"description": "WIIIIIII!!!!!",
	"points_special": 0,
	"points_falling": 0,
	"special": "*",
}

func init_vars():
	randomize()
	PENALTY = 1
	GAME_OVER = false
	delay_in_count = 0.0
	death_bar = 80.0
	board = []
	pitch = pitch_min
	SPIDERS = 0
	SCORE = 0
	THIS_TURN_SCORE = 0
	LEVEL = 1
	DEATH_SPEED = 10
	MONSTA_NEXT = []
	FULL_MONSTAS = [monsta_vampire, monsta_cyclops, monsta_tentacles, monsta_slime]
	ALL_MONSTAS = [monsta_poop, monsta_fish, monsta_zombie]
	for i in range(5):
		MONSTA_NEXT.append(pick_random(ALL_MONSTAS))

func get_pitch():
	var prev = pitch
	pitch += 0.1
	if pitch > pitch_max:
		pitch = pitch_min

	return prev

func init_music():
	TitleTheme = load("res://music/slow.mp3")
	MainTheme = load("res://music/fast.mp3")
	SpiderAddedSFX = load("res://sfx/Kefka Laugh Sound Effect.mp3")
	GunMoveSFX = load("res://sfx/click9.mp3")
	MonstaJumpSFX = load("res://sfx/Deep Gulp Sound Effect.mp3")
	ShootSFX = load("res://sfx/spring.mp3")
	ComboSFX = load("res://sfx/cococombo.mp3")
	SpiderHaul = load("res://sfx/SpiderHaul.wav")
	Chew = load("res://sfx/chewing.wav")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	init_vars()
	init_music()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		Global.FULLSCREEN = !Global.FULLSCREEN
		apply_fullscreen()
	
func apply_fullscreen():
	if Global.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func emit(_global_position, count, particle_obj = null, size = 1):
	var part = particle
	if particle_obj:
		part = particle_obj
	
	for i in range(count):
		var p = part.instantiate()
		p.global_position = _global_position
		p.size = size
		add_child(p)
		
func get_weighted_random_monster(board):
	var weights = {}
	var monsters = ALL_MONSTAS
	# 1. pesos base
	for m in monsters:
		weights[m] = 1.0

	# 2. analizar tablero y sumar pesos
	for m in monsters:
		var score = evaluate_monster_potential(board, m)
		weights[m] += score

	# 3. elegir weighted random
	return weighted_pick(weights)
		
func evaluate_monster_potential(board, monster) -> float:
	var score = 0.0
	var lines = get_all_lines(board)

	for line in lines:
		var count = 0
		var empty = 0

		for cell in line:
			if cell == null:
				empty += 1
			elif cell.id == monster.id:
				count += 1
			
		# caso fuerte: 2 + 1 vacío → casi combo
		if count == 2 and empty == 1:
			score += 3.0

		# caso leve: 1 + 2 vacíos → potencial
		elif count == 1 and empty == 2:
			score += 1.0

	return score
	
func weighted_pick(weights: Dictionary):
	var total = 0.0

	for w in weights.values():
		total += w

	var r = randf() * total
	var cumulative = 0.0

	for key in weights.keys():
		cumulative += weights[key]
		if r <= cumulative:
			return key

	return weights.keys()[0] # fallback
		
func get_all_lines(board):
	var lines = []

	# filas
	for y in range(5):
		lines.append([board[y][0], board[y][1], board[y][2], board[y][3], board[y][4]])

	# columnas
	for x in range(5):
		lines.append([board[0][x], board[1][x], board[2][x], board[3][x], board[4][x]])

	return lines
	
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
