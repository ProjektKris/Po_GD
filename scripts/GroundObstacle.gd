extends StaticBody2D

# exports

# the speed of the ground obstacle in pixels/s, default: 400.0
export var speed = 400.0

# the spawn position of the ground obstacle
# default: Vector2(1280, 450)
export(Vector2) var spawn_position = Vector2(1280, 450)

# the end of line for the ground obstacle
# default: Vector2(-100, 450)
export(Vector2) var end_position = Vector2(-100, 450)

func _process(delta: float) -> void:
    if position.x >= end_position.x:
        position -= Vector2(speed * delta, 0)
    else:
        print("GroundObstacle leaving")
        queue_free()