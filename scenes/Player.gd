extends "res://scenes/Craft.gd"

const DEFAULT_SPEED = 19
const FAST_SPEED = 35
const SLOW_SPEED = 9
const ACCEL = 4

const ROTATION_RATE = 1.5 * PI
const ROTATION_ACCEL = 5

const TRAIL_PER_SECOND = 40
const TRAIL_TIMEOUT = 1.5

export (bool) var is_two_player_mode = false
export (bool) var is_player_two = false

func _ready():
    add_to_group("Player")
    is_enemy = false
    $P2Mesh.hide()

func enable_two_player(is_p2):
    is_two_player_mode = true
    is_player_two = is_p2
    
    if is_p2:
        $Mesh.hide()
        $P2Mesh.show()
        direction = Vector3.BACK
        target_rotation = PI
        current_rotation = target_rotation
        $Hitbox.set_collision_mask_bit(1, false)
        $Hitbox.set_collision_mask_bit(3, true)

func _create_trail(delta, num_per_second, timeout=3.0, collision_layer_bit=1, enemy_layer_bit=3, use_p2_material=false):
    # Correct for p2
    collision_layer_bit = 3 if is_player_two else 1
    enemy_layer_bit = 1 if is_player_two else 3
    use_p2_material = is_player_two
    ._create_trail(delta, num_per_second, timeout, collision_layer_bit, enemy_layer_bit, use_p2_material)

func _physics_process(delta):
    if !is_player_two:
        if Input.is_action_pressed("turn_left"):
            target_rotation += ROTATION_RATE * delta
        if Input.is_action_pressed("turn_right"):
            target_rotation -= ROTATION_RATE * delta
        if Input.is_action_pressed("speed_up"):
            target_speed = FAST_SPEED
        elif Input.is_action_pressed("slow_down"):
            target_speed = SLOW_SPEED
        else:
            target_speed = DEFAULT_SPEED
    else:
        if Input.is_action_pressed("p2_turn_left"):
            target_rotation += ROTATION_RATE * delta
        if Input.is_action_pressed("p2_turn_right"):
            target_rotation -= ROTATION_RATE * delta
        if Input.is_action_pressed("p2_speed_up"):
            target_speed = FAST_SPEED
        elif Input.is_action_pressed("p2_slow_down"):
            target_speed = SLOW_SPEED
        else:
            target_speed = DEFAULT_SPEED

    current_rotation = lerp(current_rotation, target_rotation, ROTATION_ACCEL * delta)
    direction = Vector3.FORWARD.rotated(Vector3.UP, current_rotation)
    current_speed = lerp(current_speed, target_speed, ACCEL * delta)

    _create_trail(delta, TRAIL_PER_SECOND, TRAIL_TIMEOUT)
    _move_and_bounce()

func _on_Hitbox_body_entered(body):
    _die()

func _on_Hitbox_area_entered(area):
    _die()

func _die():
    if is_dying:
        return
    var level = get_tree().get_nodes_in_group("level")[0]
    level.done()
    if is_two_player_mode:
        if is_player_two:
            Score.increment_score()
        else:
            Score.increment_p2_score()
        Score.pause_score()
    ._die()
