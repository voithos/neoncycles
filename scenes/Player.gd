extends "res://scenes/Craft.gd"

const DEFAULT_SPEED = 20
const FAST_SPEED = 30
const SLOW_SPEED = 10
const ACCEL = 4

const ROTATION_RATE = 1.5 * PI
const ROTATION_ACCEL = 5

func _ready():
    add_to_group("Player")

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

    _move_and_bounce()

func _die():
    queue_free()

func _on_Hitbox_body_entered(body):
    _die()
