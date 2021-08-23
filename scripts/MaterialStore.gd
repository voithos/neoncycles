extends Node

var materials = []
var is_initialized = false

func init_transparent_materials(template, alphas):
    if is_initialized:
        return
    for alpha in alphas:
        var material = template.duplicate()
        material.albedo_color = Color(material.albedo_color.r, material.albedo_color.g, material.albedo_color.b, alpha)
        materials.push_back(material)
    is_initialized = true

func get_material(value):
    var i = clamp(int(materials.size() * value), 0, materials.size() - 1)
    return materials[i]
