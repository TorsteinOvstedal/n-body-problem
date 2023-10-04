@tool

class_name EditorInputField

extends Control

signal value_changed(value)

var name_label: Label
# var values: Array[LineEdit]

var node
var property: String

func bind(node: Object, property: String, label: String = "") -> void:
	assert(node and node.get(property), "Cannot bind to %s, %s" % [str(node), property])
	if self.node:
		release_focus()
	self.node     = node
	self.property = property
	
	if label == "":
		set_label(property)
	else:
		set_label(label)

func bound() -> bool:
	return node != null
	
func unbind() -> void:
	node = null
	property = ""

func submit() -> void:
	if is_valid():
		var value = get_value()
		node.set(property, value)
		value_changed.emit(value)

func get_label() -> String:
	return name_label.text

func set_label(text: String) -> void:
	name_label.text = text

# Abstract methods

func is_valid():
	pass

func get_value():
	pass
	
func set_value(value):
	pass
