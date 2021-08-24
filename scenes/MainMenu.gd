extends Spatial

func _ready():
    Music.play_menu()
    Score.reset()

func _process(delta):
    pass

func _on_SinglePlayer_pressed():
    get_tree().change_scene("res://scenes/Arena.tscn")
