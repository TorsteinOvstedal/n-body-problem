class_name Line3D

extends MeshInstance3D

const primitive := Mesh.PRIMITIVE_LINES

var immediate_mesh: ImmediateMesh
	x
func _init():
	immediate_mesh = ImmediateMesh.new()
	mesh = immediate_mesh

	var material = ORMMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	material_override = material
	
func begin():
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(primitive)
		
func end():
	immediate_mesh.surface_end()

func add(vertex: Vector3):
	immediate_mesh.surface_add_vertex(vertex)
