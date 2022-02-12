extends RigidBody2D

signal hit;

# exports
export var jump_force = 600.0
export var crouch_force = 10000.0
export var ground_position = 425.0

var screen_size: Vector2

func _ready() -> void:
	# signals
	var e := connect("body_entered", self, "_on_Player_body_entered")
	if e != 0:
		print(e)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		if position.y >= ground_position:
			linear_velocity += Vector2(0, -jump_force)
			$AnimatedSprite.animation = "default"

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		applied_force += Vector2(0, crouch_force)

		$AnimatedSprite.animation = "crouch"
		$CrouchCollision.disabled = false
		$DefaultCollision.disabled = true
	else:
		applied_force = Vector2(0, 0)

		$AnimatedSprite.animation = "default"
		$CrouchCollision.disabled = true
		$DefaultCollision.disabled = false
	pass

func _on_Player_body_entered(body: StaticBody2D) -> void:
	print("on player body entered")
	if body.is_in_group("obstacle"):
		print("player collided with an obstacle")

		mode = RigidBody2D.MODE_STATIC

		# hide player char
		hide()

		emit_signal("hit")

	pass

func start(pos: Vector2) -> void:
	# set position
	position = pos

	print("showing player")

	# unhide player char
	show()

	mode = RigidBody2D.MODE_CHARACTER

	pass
