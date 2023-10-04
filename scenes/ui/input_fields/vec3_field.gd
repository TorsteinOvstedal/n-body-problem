@tool

extends Control

signal value_changed(vec3: Vector3)

@onready var input0 := $layout/value0
@onready var input1 := $layout/value1
@onready var input2 := $layout/value2

@onready var inputs := [input0, input1, input2]

var node
var property

func bind(node, property) -> void:
	self.node = node
	self.property = property

func submit(i: int, s: String) -> void:
	var v = node.get(property)
	if s.is_valid_float():
		var value = s.to_float()
		v[i] = value
		node.set(property, v)
		value_changed.emit(v)

func _on_x_changed(new_text: String) -> void:
	submit(0, new_text)

func _on_y_changed(new_text: String) -> void:
	submit(1, new_text)

func _on_z_changed(new_text: String) -> void:
	submit(2, new_text)
	
func _on_vec3_submitted(new_text):
	var vec3 = node.get(property)
	
	for i in range(3):
		inputs[i].text = str(vec3[i])
		inputs[i].release_focus()

func _physics_process(_delta: float) -> void:
	if node == null:
		return
	
	var v = node.get(property)
	
	for i in range(3):
		if not inputs[i].has_focus():
			inputs[i].text = "%.2f" % v[i]
