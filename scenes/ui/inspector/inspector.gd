extends Panel

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
	
	v.bind(target, "velocity")
	p.bind(target, "position")
	
	var res = target.physics
	
	body_name.bind(res, "name", "", false)
	radius.bind(res, "radius")
	gravity.bind(res, "gravity")
	v0.bind(res, "initial_velocity")
