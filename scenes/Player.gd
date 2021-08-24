extends "res://scenes/Craft.gd"

const DEFAULT_SPEED = 19
const FAST_SPEED = 35
const SLOW_SPEED = 9
const ACCEL = 4

const ROTATION_RATE = 1.5 * PI
const ROTATION_ACCEL = 5

const TRAIL_PER_SECOND = 40
const TRAIL_TIMEOUT = 1.5

func _ready():
    add_to_group("Player")
    is_enemy = false

func _physics_process(delta):
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
    var level = get_tree().get_nodes_in_group("level")[0]
    level.done()
    ._die()
