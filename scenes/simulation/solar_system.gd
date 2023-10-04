class_name SolarSystem

extends Node3D

signal body_entered(body)
signal body_exited(body)

@export
var timestep := 0.06

var running  := false
var tick     := 0

@onready
var active_bodies := $celestial_bodies

var pending_queue    := []
var completion_queue := []

# const BodyInstance := preload("res://scenes/simulation/body.tscn")

func create_body() -> Body:
	var body := Body.new() # BodyInstance.instantiate()
	init_body(body)
	return body
	
func init_body(body: Body) -> void:
	body.state = Body.State.INACTIVE
	body.connect("crashed", _on_collision)

func add_body(body: Body) -> void:
	pending_queue.push_back(body)
	body.state = Body.State.PENDING

func remove_body(body: Body) -> void:
	print("REMOVE ", body, ". Status: ", body.state)

	if body.state == Body.State.PENDING:
		var index := pending_queue.find(body)
		pending_queue.remove_at(index)
		body.state = Body.State.INACTIVE
	
	elif body.state == Body.State.ACTIVE:
		completion_queue.push_back(body)
	
	else:
		pass
		
func reset() -> void:
	running = false
	tick    = 0
	
	for body in get_active_bodies():
		remove_body(body)
	
	for body in pending_queue:
		remove_body(body)
	
	while completion_queue.size() > 0:
		var body: Body = completion_queue.pop_front()
		_body_exit(body)

## Handle collision between two bodies.

func _on_collision(body0: Body, body1: Body) -> void:
	print_debug(body0.name, " collided with ", body1.name)
	
	# If significant mass difference, destroy the smaller one.
	# Destroy both if similar mass.

	const tresh_hold := 0.5
	const max_pieces := 5
	const min_pieces := 0

	var cmp := body1.physics.mass / body0.physics.mass
	
	var destroy = func lambda(body):
		completion_queue.append(body)
		var r = body.physics.radius
		var g = body.physics.gravity
		var pieces = (randi() % (max_pieces + 1)) + min_pieces
		for i in range(pieces):
			pass
		print(body, " was destroyed")

	if cmp >= 1.0 + tresh_hold:
		destroy.call(body0)

	elif cmp <= tresh_hold:
		destroy.call(body1)

	else:
		destroy.call(body0)
		destroy.call(body1)

## Returns the active bodies in the simulation.
## 
func get_active_bodies():
	return active_bodies.get_children()
	
func _body_enter(body: Body) -> void:
	if body.is_inside_tree():
		print("warning: ", body.physics.name, " is already in the tree.")
		return

	active_bodies.add_child(body)
	body.state = Body.State.ACTIVE
	body_entered.emit(body)
	
func _body_exit(body: Body) -> void:
		if body.get_parent() == active_bodies:
			active_bodies.remove_child(body)

		body.state = Body.State.INACTIVE
		body_exited.emit(body)

func _physics_process(_delta: float) -> void:
	# Add pending bodies to active list (scene tree).
	while pending_queue.size() > 0:
		var body: Body = pending_queue.pop_front()
		_body_enter(body)
	
	# Run simulation step.
	if running:
		var bodies = get_active_bodies()

		for body in bodies:
			body.update_velocity(timestep, bodies)

		for body in bodies:
			body.update_position(timestep)
			
		tick += 1
	
	# Remove complete bodies.
	while completion_queue.size() > 0:
		var body: Body = completion_queue.pop_front()
		_body_exit(body)
