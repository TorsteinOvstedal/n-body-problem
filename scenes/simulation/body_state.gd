class_name BodyState

extends Resource

signal radius_changed
signal mass_changed
signal gravity_changed

## Newtonian constant of gravitation

const G := 6.67430e-11

# Body properties

@export
var name    := ""

@export 
var radius  := 1.0: set = set_radius

@export
var gravity := 1.0: set = set_gravity

var mass    := 1.0

@export 
var initial_velocity := Vector3.ZERO

@export
var initial_position := Vector3.ZERO

func set_mass(m: float) -> void:
	mass = m
	mass_changed.emit()

func set_radius(r: float) -> void:
	radius = r
	radius_changed.emit()

	var m = calculate_mass(radius, gravity)
	set_mass(m)
	
func set_gravity(g: float) -> void:
	gravity = g
	gravity_changed.emit()
	
	var m = calculate_mass(radius, gravity)
	set_mass(m)

func calculate_mass(r: float, g: float) -> float:
	return g * r * r / G
