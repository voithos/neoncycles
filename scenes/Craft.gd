extends KinematicBody

var velocity = Vector3.ZERO

var is_enemy = true

var current_speed = 0.0
var target_speed = 0.0

var target_rotation = 0.0
var current_rotation = 0.0
var direction = Vector3.FORWARD

var last_trail = 0.0
var is_ready = true
var is_dying = false

var gotcalled = false

func _ready():
    if has_node("Explosion"):
        $Explosion.emitting = false

func _spawn_enemy():
    assert(!gotcalled)
    gotcalled = true
    is_ready = false
    $AnimationPlayer.play("spawn")
    yield($AnimationPlayer, "animation_finished")
    is_ready = true

func _move_and_bounce():
    if is_dying or !is_ready:
        return
    look_at(translation + 100*direction, Vector3.UP)
    
    velocity = direction * current_speed
    velocity = move_and_slide(velocity, Vector3.UP)
    translation.y = 0

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
    if is_dying or !is_ready:
        return
    last_trail += delta
    if last_trail < 1.0 / num_per_second:
        return
    last_trail = 0.0
    var t = preload("res://scenes/Trail.tscn").instance()
    get_parent().add_child(t)
    t.timeout = timeout
    t.collision_layer_bit = collision_layer_bit
    t.enemy_layer_bit = enemy_layer_bit
    t.global_transform.origin = global_transform.origin - direction
    t.look_at(global_transform.origin, Vector3.UP)

func _die():
    if is_dying:
        return
    is_dying = true
    if is_enemy:
        Score.increment_score()
    if has_node("Explosion"):
        $Explosion.one_shot = true
        $Explosion.emitting = true
        $Mesh.hide()
        if is_enemy:
            Sfx.play(Sfx.ENEMY_EXPLOSION, Sfx.SFX_DB)
            GlobalCamera.shake(0.25, 30, 0.5)
        else:
            Sfx.play(Sfx.PLAYER_EXPLOSION, Sfx.SFX_DB)
            GlobalCamera.shake(0.5, 30, 3)
        yield(get_tree().create_timer(0.5), "timeout")
    queue_free()
