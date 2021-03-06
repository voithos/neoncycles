extends Area

const MAX_ALPHA = 0.8
const MIN_COLLISION_ALPHA = 0.1
var timer = 0
var timeout = 3.0
var self_deadly_timeout = 0.5
var collision_layer_bit = 1
var enemy_layer_bit = 3

var use_p2_material = false

func _ready():
    var alphas = []
    var a = 0.0
    while a <= MAX_ALPHA:
        alphas.push_back(a)
        a += 0.05
    if use_p2_material:
        $MeshInstance.hide()
        MaterialStore.init_transparent_materials_p2($P2MeshInstance.get_surface_material(0), alphas)
    else:
        $P2MeshInstance.hide()
        MaterialStore.init_transparent_materials($MeshInstance.get_surface_material(0), alphas)

func _physics_process(delta):
    var alpha_v = range_lerp(timer, 0, timeout, 1.0, 0.0)
    if use_p2_material:
        $P2MeshInstance.set_surface_material(0, MaterialStore.get_material_p2(alpha_v))
    else:
        $MeshInstance.set_surface_material(0, MaterialStore.get_material(alpha_v))

    timer += delta
    if alpha_v < MIN_COLLISION_ALPHA:
        monitorable = false
    var is_self_deadly = timer > self_deadly_timeout
    set_collision_layer_bit(collision_layer_bit, is_self_deadly)
    set_collision_mask_bit(collision_layer_bit, is_self_deadly)
    set_collision_layer_bit(enemy_layer_bit, true)
    set_collision_mask_bit(enemy_layer_bit, true)
    
    if timer > timeout:
        queue_free()
