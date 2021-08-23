extends Node

func _ready():
    pass

func shake(duration, frequency, amplitude):
    var camera = get_tree().get_nodes_in_group("camera")[0]
    camera.shake(duration, frequency, amplitude)
