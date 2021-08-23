extends CanvasLayer

func _ready():
    Score.connect("score_changed", self, "score_changed")

func score_changed(score):
    $RichTextLabel.text = "Score: " + str(score)
