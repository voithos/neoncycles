extends KinematicBody

var velocity = Vector3.ZERO

var current_speed = 0.0
var target_speed = 0.0

var target_rotation = 0.0
var current_rotation = 0.0
var direction = Vector3.FORWARD

var last_trail = 0.0

func _move_and_bounce():
    look_at(translation + 100*direction, Vector3.UP)
    
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

    target_rotation = _rotation_from_direction(bounce_dir)
    current_rotation = target_rotation

func _rotation_from_direction(dir):
    var dot = Vector3.FORWARD.x * dir.x + Vector3.FORWARD.z * dir.z
    var det = Vector3.FORWARD.x * dir.y - Vector3.FORWARD.z * dir.x
    return -atan2(det, dot)

func _create_trail(delta, num_per_second, timeout=3.0, collision_layer_bit=1, enemy_layer_bit=3):
    last_trail += delta
    if last_trail < 1.0 / num_per_second:
        return
    last_trail = 0.0
    var t = preload("res://scenes/Trail.tscn").instance()
    get_parent().add_child(t)
    t.timeout = timeout
    t.collision_layer_bit = collision_layer_bit
    t.enemy_layer_bit = enemy_layer_bit
    t.translation = translation - direction
    t.look_at(translation, Vector3.UP)

func _die():
    queue_free()
