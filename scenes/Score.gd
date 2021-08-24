extends CanvasLayer

export (bool) var is_two_player = false

func _ready():
    Score.connect("score_changed", self, "score_changed")
    Score.connect("p2_score_changed", self, "p2_score_changed")
    Score.send_updates()
    
    if !is_two_player:
        $P2Score.hide()

func score_changed(score):
    if is_two_player:
        $RichTextLabel.text = "P1 Score: " + str(score)
    else:
        $RichTextLabel.text = "Score: " + str(score)

func p2_score_changed(score):
    $P2Score.text = "P2 Score: " + str(score)
