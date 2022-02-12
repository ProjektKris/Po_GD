extends CanvasLayer

class_name UI

# A signal that fires when the game is about to be started.
signal game_starting

func _ready() -> void:
    var e := $StartButton.connect("pressed", self, "_on_StartButton_pressed")
    if e != OK:
        push_error("Failed to connect _on_StartButton_pressed to $StartButton.pressed: %d" % e)

    e = $MessageTimer.connect("timeout", self, "_on_MessageTimer_timeout")
    if e != OK:
        push_error("Failed to connect _on_MessageTimer_timeout to $MessageTimer.timeout: %d" % e)

func show_message(text: String) -> void:
    $Message.text = text
    $Message.show()
    $MessageTimer.start()

func show_game_over() -> void:
    show_message("Game Over")

    # yield until timeout signal is fired
    yield($MessageTimer, "timeout")

    $Message.text = "Po!"
    $Message.show()

    yield(get_tree().create_timer(1), "timeout")

    $StartButton.show()

func update_score(score: int) -> void:
    $ScoreLabel.text = String(score)

func _on_StartButton_pressed() -> void:
    $StartButton.hide()
    emit_signal("game_starting")

func _on_MessageTimer_timeout() -> void:
    print("message timeout: hiding message")
    $Message.hide()