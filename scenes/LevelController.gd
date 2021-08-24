extends CanvasLayer

var is_done = false
signal done

func _ready():
    add_to_group("level")
    $RichTextLabel.hide()

func _physics_process(delta):
    if is_done:
        if Input.is_action_just_pressed("reset_level"):
            var transition = get_tree().get_nodes_in_group("transition")[0]
            transition.connect("fade_complete", self, "_reset_scene")
            transition.begin_fade()
        if Input.is_action_just_pressed("main_menu"):
            var transition = get_tree().get_nodes_in_group("transition")[0]
            transition.connect("fade_complete", self, "_load_main_menu")
            transition.begin_fade()

func _reset_scene():
    get_tree().reload_current_scene()

func _load_main_menu():
    get_tree().change_scene("res://scenes/MainMenu.tscn")

func done():
    # Gameplay done for now; listen for reset
    is_done = true
    $RichTextLabel.show()
    emit_signal("done")
