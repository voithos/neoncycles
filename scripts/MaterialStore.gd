extends Node

var materials = []
var materials_p2 = []
var is_initialized = false
var is_initialized_p2 = false

func init_transparent_materials(template, alphas):
    if is_initialized:
        return
    for alpha in alphas:
        var material = template.duplicate()
        material.albedo_color = Color(material.albedo_color.r, material.albedo_color.g, material.albedo_color.b, alpha)
        materials.push_back(material)
    is_initialized = true

func init_transparent_materials_p2(template, alphas):
    if is_initialized_p2:
        return
    for alpha in alphas:
        var material = template.duplicate()
        material.albedo_color = Color(material.albedo_color.r, material.albedo_color.g, material.albedo_color.b, alpha)
        materials_p2.push_back(material)
    is_initialized_p2 = true

func get_material(value):
    var i = clamp(int(materials.size() * value), 0, materials.size() - 1)
    return materials[i]

func get_material_p2(value):
    var i = clamp(int(materials_p2.size() * value), 0, materials_p2.size() - 1)
    return materials_p2[i]
