extends Node

var score = 0
var p2_score = 0
var is_paused = false
signal score_changed
signal p2_score_changed

func increment_score():
    if is_paused:
        return
    score += 1
    send_updates()

func increment_p2_score():
    if is_paused:
        return
    p2_score += 1
    send_updates()

func reset():
    score = 0
    p2_score = 0
    is_paused = false
    send_updates()

func send_updates():
    emit_signal("score_changed", score)
    emit_signal("p2_score_changed", p2_score)

func pause_score():
    is_paused = true

func unpause_score():
    is_paused = false
