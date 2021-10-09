extends CanvasLayer

# signals
# a signal that fires when the game starts
signal start_game

func _ready() -> void:
    # signals
    var e := $StartButton.connect("pressed", self, "_on_StartButton_pressed")
    if e != 0:
        print(e)
    e = $MessageTimer.connect("timeout", self, "_on_MessageTimer_timeout")
    if e != 0:
        print(e)
    pass

func show_message(text: String) -> void:
    $Message.text = text
    $Message.show()
    $MessageTimer.start()
    pass

func show_game_over() -> void:
    show_message("Game Over")

    # yield until timeout signal is fired
    yield($MessageTimer, "timeout")

    $Message.text = "Po!"
    $Message.show()

    yield(get_tree().create_timer(1), "timeout")

    $StartButton.show()

    pass

func update_score(score: int) -> void:
    $ScoreLabel.text = String(score)
    pass

func _on_StartButton_pressed() -> void:
    $StartButton.hide()
    emit_signal("start_game")
    pass

func _on_MessageTimer_timeout() -> void:
    print("message timeout: hiding message")
    $Message.hide()