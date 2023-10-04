extends Node3D

@onready 
var simulation := $solar_system

@onready 
var camera     := $camera

@onready
var ui :       = $ui

var initial_state: State = null

# const sun_scene := preload("res://scenes/simulation/sun.tscn")

# var sun := sun_scene.instantiate()

const body_scene := preload("res://scenes/simulation/body.tscn")

func init_body(body: Body) -> void:
	simulation.init_body(body)

	body.connect("picked", _on_sim_body_picked)


func _init() -> void:
	var star_field := create_starfield(1000)
	add_child(star_field)

func _ready() -> void:
	# DEVELOPMENT DEBUGGING ----------------------------------------------------
	
	# Save body state given in godot editor
	initial_state = save_state()
	
	# Do missing initialization...	
	for body in simulation.get_active_bodies():
		body.state = Body.State.ACTIVE
		init_body(body)
		simulation.active_bodies.remove_child(body)
	
	# Build scene
	restore_state(initial_state)
	# --------------------------------------------------------------------------

	simulation.running = false
	
	## Simulation signals.
	
	simulation.body_entered.connect(_on_sim_body_entered)
	simulation.body_exited.connect(_on_sim_body_exited)
	
	camera.no_target.connect(_on_camera_no_target)
	
	# Editor Simulation Control signals.
	
	ui.connect("reset", _on_editor_reset)
	ui.connect("play",  _on_editor_play)
	ui.connect("pause", _on_editor_pause)

	# Editor Simulation Body Overview signals.
	
	ui.entries.connect("add_request",    _on_editor_add_body)
	ui.entries.connect("select_request", _on_editor_select_body)
	ui.entries.connect("remove_request", _on_editor_remove_body)

func _on_sim_body_entered(body: Body) -> void:
	print(body, " entered.")
	ui.entries.add_body(body)

func _on_sim_body_exited(body: Body) -> void:
	print(body, " exited.")
	ui.entries.remove_body(body)
	
func select_body(body: Body) -> void:
	camera.target = body
	ui.inspector.inspect(body)	
	
func _on_sim_body_picked(body: Body) -> void:
	select_body(body)

func _on_camera_no_target() -> void:
	var bodies = simulation.get_active_bodies()
	if bodies.size() > 0:
		select_body(bodies[0])



func _on_editor_reset() -> void:
	# fix
	if simulation.running:
		ui.run_btn.toggle()

	restore_state(initial_state)
	
func _on_editor_play() -> void:
	simulation.running = true

func _on_editor_pause() -> void:
	simulation.running = false


## Creates a new body and adds it to the simulation.

func _on_editor_add_body() -> void: 
	var body = body_scene.instantiate()
	init_body(body)
	
	# Generate temporary name
	var n_bodies = simulation.pending_queue.size() + simulation.get_active_bodies().size()
	body.physics.name = "Planet%d" % [n_bodies + 1]

	simulation.add_body(body)

func _on_editor_select_body(entry: Entry) -> void:
	select_body(entry.ref)

func _on_editor_remove_body(entry: Entry) -> void:
	simulation.remove_body(entry.ref)
	

## Save and load simulation state.

class State extends RefCounted:
	
	var refs:   Array[Body] = []
	
	func size() -> int:
		return refs.size()

func save_state(state: State = null) -> State:
	if not state:
		state = State.new()
	
	if not simulation:
		call_deferred("save_state")
		print("save state failed.")
		return state
		
	for body in simulation.get_active_bodies():
		state.refs.append(body)
		body.physics.initial_position = body.position

	return state

func restore_state(state: State) -> void:
	# Clear simulation
	simulation.reset()

	assert(simulation.active_bodies.get_child_count() == 0)
	
	# Repopulate with initial state.
	for body in state.refs:
		body.reset()
		simulation.add_body(body)


## Generate starfield mesh.

const DistantStar := preload("res://scenes/utils/distant_star.tscn")

func create_starfield(stars: int = 500, min: float = -200, max: float = 200) -> Node3D:
	var star_field := Node3D.new()

	for i in range(stars):
		var star = DistantStar.instantiate()
		var x = randf_range(min, max)
		var y = randf_range(min, max)
		var z = randf_range(min, max)
		star.position = Vector3(x, y, z)
		star_field.add_child(star)
		
	return star_field
