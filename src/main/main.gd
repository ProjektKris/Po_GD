extends Node2D

# The scene containing the ground obstacle
export(PackedScene) var ground_obstacle_scene

# The scene containing the air obstacle
export(PackedScene) var air_obstacle_scene

# The starting `speed` of the `Player`. `default: 400.0`
export var starting_speed: float = 400.0

# TODO: implement speed acceleration
export var speed_accel = 20.0

var score: int
onready var _player: Player = get_node("Player")
onready var _UI: UI = get_node("UI")

func _ready():
	# signals
	var code := _UI.connect("game_starting", self, "_on_new_game")
	if code != OK:
		push_error("Failed to connect _on_new_game to _UI.game_starting: %d" % code)

	code = $ObstacleTimer.connect("timeout", self, "_on_ObstacleTimer_timeout")
	if code != OK:
		push_error("Failed to connect _on_ObstacleTimer_timeout to $ObstacleTimer.timeout: %d" % code)

	code = $ScoreTimer.connect("timeout", self, "_on_ScoreTimer_timeout")
	if code != OK:
		push_error("Failed to connect _on_ScoreTimer_timeout to $ScoreTimer.timeout: %d" % code)

	code = $StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	if code != OK:
		push_error("Failed to connect _on_StartTimer_timeout to $StartTimer.timeout: %d" % code)

	code = _player.connect("hit", self, "_on_game_over")
	if code != OK:
		push_error("Failed to connect _on_game_over to _player.hit: %d" % code)

func _on_game_over() -> void:
	$ScoreTimer.stop()
	$ObstacleTimer.stop()
	_UI.show_game_over()
	get_tree().call_group("obstacle", "queue_free")
	pass

func _on_new_game() -> void:
	# reset score
	score = 0

	# set the player pos
	_player.start($PlayerPosition.position)

	# start countdown timer
	$StartTimer.start()

	# update hud score
	_UI.update_score(score)

	# show "get ready" message
	_UI.show_message("Get Ready")

func _on_ObstacleTimer_timeout() -> void:
	print("spawning ground obstacle")
	
	var new_obstacle: StaticBody2D
	match randi()%2+1:
		1: new_obstacle = ground_obstacle_scene.instance()
		2: new_obstacle = air_obstacle_scene.instance()
	
	add_child(new_obstacle)
	
	new_obstacle.position = $ObstacleStart.position
	
	# rng for next timeout
	randomize()
	$ObstacleTimer.wait_time = rand_range(1.5, 3.0)

func _on_ScoreTimer_timeout() -> void:
	score += 1
	_UI.update_score(score)

func _on_StartTimer_timeout() -> void:
	print("start timer timeout")
	$ScoreTimer.start()
	$ObstacleTimer.start()
