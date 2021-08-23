extends "res://scenes/Craft.gd"

const DEFAULT_SPEED = 15
const ACCEL = 3

const ROTATION_ACCEL = 1

func _physics_process(delta):
    var player = get_tree().get_nodes_in_group("Player")[0]
    var player_dir = (player.global_transform.origin - global_transform.origin).normalized()
    
    direction.x = lerp(direction.x, player_dir.x, ROTATION_ACCEL * delta)
    direction.z = lerp(direction.z, player_dir.z, ROTATION_ACCEL * delta)
    
    target_speed = DEFAULT_SPEED
    current_speed = lerp(current_speed, target_speed, ACCEL * delta)
    _move_and_bounce()
