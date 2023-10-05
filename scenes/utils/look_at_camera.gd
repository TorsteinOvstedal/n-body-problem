class_name LookAtCamera

extends Camera3D

signal no_target

var target: Node3D = null

var requested := false

# var speed = 2
# var target_distance = 300

func set_target(path: NodePath) -> void:
	target = get_node_or_null(path)

func _unhandled_input(event):
	pass
	
	if event is InputEventMouseButton:
		if event.button_index == 4:
			var d = global_position.direction_to(target.global_position)
			position += d * 4
		elif event.button_index == 5:
			var d = global_position.direction_to(target.global_position)
			position -= d * 4
	
func _physics_process(delta: float) -> void:
	if target and target.is_inside_tree():
		look_at(target.global_position)
			
		
		# Stationary camera for now.
		# var distance = global_position.distance_squared_to(target.global_position)
		# if distance > target_distance:
		# 	position += global_position.direction_to(target.global_position) * speed * delta
		# elif distance < target_distance:
		# 	position -= global_position.direction_to(target.global_position) * speed * delta
		
		requested = false

	elif not requested:
		no_target.emit()
		requested = true

