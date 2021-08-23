extends Area

const MAX_ALPHA = 0.9
const MIN_COLLISION_ALPHA = 0.2
var timer = 0
var timeout = 3.0
var self_deadly_timeout = 0.5
var collision_layer_bit = 1
var enemy_layer_bit = 3

func _ready():
    pass

func _physics_process(delta):
    var alpha = range_lerp(timer, 0, timeout, MAX_ALPHA, 0)
    var material = $MeshInstance.get_surface_material(0)
    material.albedo_color = Color(material.albedo_color.r, material.albedo_color.g, material.albedo_color.b, alpha)
    $MeshInstance.set_surface_material(0, material)

    timer += delta
    if alpha < MIN_COLLISION_ALPHA:
        monitorable = false
    var is_self_deadly = timer > self_deadly_timeout
    set_collision_layer_bit(collision_layer_bit, is_self_deadly)
    set_collision_mask_bit(collision_layer_bit, is_self_deadly)
    set_collision_layer_bit(enemy_layer_bit, true)
    set_collision_mask_bit(enemy_layer_bit, true)
    
    if timer > timeout:
        queue_free()
