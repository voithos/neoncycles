extends Spatial

func _ready():
    Music.play_menu()
    Score.reset()

func _process(delta):
    pass

func _on_SinglePlayer_pressed():
    var transition = get_tree().get_nodes_in_group("transition")[0]
    transition.connect("fade_complete", self, "_load_arena")
    transition.begin_fade()

func _load_arena():
    get_tree().change_scene("res://scenes/Arena.tscn")


func _on_MultiPlayer_pressed():
    var transition = get_tree().get_nodes_in_group("transition")[0]
    transition.connect("fade_complete", self, "_load_battle")
    transition.begin_fade()

func _load_battle():
    get_tree().change_scene("res://scenes/Battle.tscn")
