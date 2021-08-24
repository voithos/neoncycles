extends Spatial

func _ready():
    Music.play_battle()
    # Don't reset score because this is 2-player; but do unpause
    Score.unpause_score()
