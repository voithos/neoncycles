extends Spatial

export (BoxShape) var spawn_shape: BoxShape
export (float) var spawn_rate = 1.0 # per second
export (float) var spawn_sigma = 0.5
export (bool) var is_active = true
export (PackedScene) var enemy = preload("res://scenes/Drone.tscn")
export (bool) var debug = false

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
        var e = enemy.instance()
        add_child(e)
        e.translation = Vector3(spawn_shape.extents.x * rand_range(-1, 1), 0, spawn_shape.extents.z * rand_range(-1, 1))
        e.get_node("Body").set_dir_towards_player()

        timer = 0
        _set_next_tick()

func _set_next_tick():
    next_tick = spawn_rate + rand_range(-1, 1) * spawn_sigma
