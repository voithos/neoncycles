extends Node

var score = 0
signal score_changed

func increment_score():
    score += 1
    emit_signal("score_changed", score)

func reset():
    score = 0
    emit_signal("score_changed", score)
