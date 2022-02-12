extends Node2D


# exports

# the scene containing the ground obstacle
export(PackedScene) var ground_obstacle_scene

# the starting speed of the player
# default: 400.0
export var starting_speed = 400.0

# todo
export var speed_accel = 20.0

# nodes
var score: int

func _ready():
	# signals
	var e = $UI.connect("start_game", self, "_on_new_game")
	if e != 0:
		print(e)
	e = $ObstacleTimer.connect("timeout", self, "_on_ObstacleTimer_timeout")
	if e != 0:
		print(e)
	e = $ScoreTimer.connect("timeout", self, "_on_ScoreTimer_timeout")
	if e != 0:
		print(e)
	e = $StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	if e != 0:
		print(e)
	e = $Player.connect("hit", self, "_on_game_over")
	if e != 0:
		print(e)
	pass

func _on_game_over() -> void:
	$ScoreTimer.stop()
	$ObstacleTimer.stop()
	$UI.call("show_game_over")
	get_tree().call_group("obstacle", "queue_free")
	pass

func _on_new_game() -> void:
	# reset score
	score = 0

	# set the player pos
	$Player.call("start", $PlayerPosition.position)

	# start countdown timer
	$StartTimer.start()

	# update hud score
	$UI.call("update_score", score)

	# show "get ready" message
	$UI.call("show_message", "Get Ready")

	pass

func _on_ObstacleTimer_timeout() -> void:
	print("spawning ground obstacle")
	
	var new_obstacle: StaticBody2D = ground_obstacle_scene.instance()
	
	add_child(new_obstacle)
	
	new_obstacle.position = $ObstacleStart.position
	
	# rng for next timeout
	randomize()
	$ObstacleTimer.wait_time = rand_range(1.5, 3.0)

	pass

func _on_ScoreTimer_timeout() -> void:
	score += 1
	$UI.call("update_score", score)
	pass

func _on_StartTimer_timeout() -> void:
	print("start timer timeout")
	$ScoreTimer.start()
	$ObstacleTimer.start()
	pass
