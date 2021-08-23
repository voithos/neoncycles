extends "res://scenes/Craft.gd"

const DEFAULT_SPEED = 15
const ACCEL = 3

const ROTATION_ACCEL = 1

var player_dir = Vector3.ZERO

func _physics_process(delta):
    var player = _get_player()
    
    target_speed = 0.0

    if player:
        target_speed = DEFAULT_SPEED
        player_dir = (player.global_transform.origin - global_transform.origin).normalized()
    
    direction.x = lerp(direction.x, player_dir.x, ROTATION_ACCEL * delta)
    direction.z = lerp(direction.z, player_dir.z, ROTATION_ACCEL * delta)
    
    current_speed = lerp(current_speed, target_speed, ACCEL * delta)
    _move_and_bounce()

func _get_player():
    var players = get_tree().get_nodes_in_group("Player")
    if players:
        return players[0]
    return null
