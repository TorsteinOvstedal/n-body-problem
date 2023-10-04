extends Panel

#const Entry := preload("res://scenes/ui/entities/entry.tscn")

@onready var properties := $scrollable/vbox
@onready var body_name  := $name
@onready var radius     := $scrollable/vbox/radius
@onready var gravity    := $scrollable/vbox/gravity
@onready var v0         := $scrollable/vbox/initial_velocity
@onready var v          := $scrollable/vbox/velocity
@onready var p          := $scrollable/vbox/position


var target = null


func inspect(new_target) -> void:
	if not new_target:
		return
	
	target = new_target
	
	var res = target.physics
	
	body_name.text = target.physics.name
	
	# radius.value_input.text  = "%.2f" % target.physics.radius
	radius.bind(res, "radius")

	# gravity.value_input.text = "%.2f" % target.physics.gravity
	gravity.bind(res, "gravity")

	# v0.value0_input.text     = "%.2f" % target.physics.initial_velocity.x
	# v0.value1_input.text     = "%.2f" % target.physics.initial_velocity.y	
	# v0.value2_input.text     = "%.2f" % target.physics.initial_velocity.z
	v0.bind(res, "initial_velocity")
	v.bind(target, "velocity")

	# p.value0_input.text     = "%.2f" % target.global_position.x
	# p.value1_input.text     = "%.2f" % target.global_position.y	
	# p.value2_input.text     = "%.2f" % target.global_position.z
	p.bind(target, "position")

# func _physics_process(delta):
# 	if target and target.state == Body.State.ACTIVE:
# 		v.value0_input.text     = "%.2f" % target.velocity.x
# 		v.value1_input.text     = "%.2f" % target.velocity.y
# 		v.value2_input.text     = "%.2f" % target.velocity.z

		# p.value_input0.text     = "%.2f" % target.global_position.x
		# p.value_input1.text     = "%.2f" % target.global_position.y
		# p.value_input2.text     = "%.2f" % target.global_position.z
