extends KinematicBody

var velocity = Vector3.ZERO

const DEFAULT_SPEED = 20
const FAST_SPEED = 30
const SLOW_SPEED = 10
const ACCEL = 4
var current_speed = 0
var target_speed = DEFAULT_SPEED

const ROTATION_RATE = 1.5 * PI
const ROTATION_ACCEL = 5
var target_rotation = 0.0
var current_rotation = 0.0
var direction = Vector3.FORWARD

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
    look_at(translation + direction, Vector3.UP)
    
    current_speed = lerp(current_speed, target_speed, ACCEL * delta)
    velocity = direction * current_speed
    velocity = move_and_slide(velocity, Vector3.UP)

    _maybe_bounce()
            
func _get_bounce_direction():
    if get_slide_count() > 0:
        var normal: Vector3 = get_slide_collision(0).normal
        normal.y = 0
        if normal != Vector3.ZERO:
            normal = normal.normalized()
            return direction.bounce(normal).normalized()
    return null

# Should be called after move_and_slide
func _maybe_bounce():
    var bounce_dir = _get_bounce_direction()
    if !bounce_dir:
        return

    var dot = Vector3.FORWARD.x * bounce_dir.x + Vector3.FORWARD.z * bounce_dir.z
    var det = Vector3.FORWARD.x * bounce_dir.y - Vector3.FORWARD.z * bounce_dir.x
    target_rotation = -atan2(det, dot)
    current_rotation = target_rotation
