extends StaticBody2D

# The speed of the obstacle in pixels/s. `default: 400.0`
export var speed: float = 400.0

func _ready():
    var code := $VisibilityNotifier2D.connect("screen_exited", self, "_on_screen_exited")
    if code != OK:
        push_error("Failed to connect _on_screen_exited: %d" % code) 

func _physics_process(delta: float):
    position -= Vector2(speed * delta, 0)
        
func _on_screen_exited():
    queue_free()