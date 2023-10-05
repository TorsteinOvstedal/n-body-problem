@tool

class_name Body

extends CharacterBody3D

signal crashed(this, other)

signal picked(this)

enum State {INACTIVE, PENDING, ACTIVE}

@export
var physics: BodyState

var state := State.INACTIVE

func update_velocity(timestep: float, bodies):
	for other in bodies:
		if self == other:
			continue

		var displacement: Vector3 = other.global_position - global_position		

		# Newton's law of universal gravitation.
		#
		# F = G * (m0 * m1) / r^2
	
		var  rr: float = displacement.length_squared()
		var  m0: float = physics.mass
		var  m1: float = other.physics.mass
		const G: float = physics.G
	
		var force := G * m0 * m1 / rr
		
		# Newton's second law of motion.
		#
		# F = m * a
	
		var acceleration := force / m0
		
		# Apply change in velocity.
	
		var direction := displacement.normalized()
		
		velocity += acceleration * direction * timestep

func update_position(timestep: float):
	var collision = move_and_collide(velocity * timestep)
	if collision:
		crashed.emit(self, collision.get_collider() as Body)

func reset() -> void:
	position = physics.initial_position
	velocity = physics.initial_velocity

func _ready() -> void:
	motion_mode = MotionMode.MOTION_MODE_FLOATING
	physics.connect("radius_changed", _on_radius_changed)
	connect("input_event", _on_input_event)

func _on_radius_changed() -> void:
	# Scale mesh
	var s := physics.radius * 2
	var mesh: MeshInstance3D = $mesh_instance
	mesh.scale = Vector3(s, s, s)
	
	# Scale collision shape
	var collision_shape: SphereShape3D = $collision_shape.shape
	collision_shape.radius = physics.radius
	
func _on_input_event(c: Camera3D, e: InputEvent, p: Vector3, n: Vector3, i: int) -> void:
	if Input.is_action_just_pressed("pick"):
		picked.emit(self)
