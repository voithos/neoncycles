extends Spatial

export (BoxShape) var spawn_shape: BoxShape
export (float) var spawn_rate = 1.0 # per second
export (float) var spawn_sigma = 0.5
export (float) var spawn_rate_speedup_time = 0 # seconds
export (float) var spawn_rate_max_speedup = 1.0 # no speedup
export (bool) var is_active = true
export (PackedScene) var enemy = preload("res://scenes/Drone.tscn")
export (bool) var debug = false

var speedup_timer = 0
var internal_spawn_rate = spawn_rate

var timer = 0
var next_tick = 0

var is_initialized = false

func _ready():
    if debug:
        var mesh = MeshInstance.new()
        mesh.mesh = spawn_shape.get_debug_mesh()
        add_child(mesh)
    randomize()
    _set_next_tick()
    
func _physics_process(delta):
    if !is_active:
        return
    
    timer += delta
    if timer > next_tick:
        var en = enemy.instance()
        add_child(en)
        var e = en.get_node("Body")
        e.translation = Vector3(spawn_shape.extents.x * rand_range(-1, 1), 0, spawn_shape.extents.z * rand_range(-1, 1))
        e.set_dir_towards_player()
        e._spawn_enemy()

        timer = 0
        _set_next_tick()
        
    speedup_timer += delta
    if spawn_rate_speedup_time != 0:
        var new_spawn_rate = range_lerp(speedup_timer, 0, spawn_rate_speedup_time, spawn_rate, spawn_rate / spawn_rate_max_speedup)
        # Don't go overboard
        internal_spawn_rate = clamp(new_spawn_rate, spawn_rate / spawn_rate_max_speedup, spawn_rate)

func _set_next_tick():
    next_tick = internal_spawn_rate + rand_range(-1, 1) * spawn_sigma
