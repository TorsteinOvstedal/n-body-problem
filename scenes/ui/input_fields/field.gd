@tool
class_name EditorInputField

extends Control

signal value_changed(value)

var name_label: Label

var node
var property: String

# show_label: bool is a hack to retro-fit field.gd as a script for just a LineEdit.

func bind(node: Object, property: String, label: String = "", show_label: bool = true) -> void:
	assert(node and node.get(property), "Cannot bind to %s, %s" % [str(node), property])
	
	if self.node:
		release_focus()
	
	self.node     = node
	self.property = property
	
	if show_label && label == "":
		set_label(property)
	elif show_label:
		set_label(label)

	elif not show_label:
		if not is_connected("text_changed", _on_changed):
			connect("text_changed", _on_changed)
		if not is_connected("text_submitted", _on_submitted):
			connect("text_submitted", _on_submitted)

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
	return true

func get_value():
	return get("text")
	
func set_value(value):
	set("text", value)
	
func _physics_process(_delta: float) -> void:
	if not bound():
		return
	
	if not has_focus():
		set_value(node.get(property))

func _on_changed(new_text: String) -> void:
	submit()

func _on_submitted(new_text: String) -> void:
	submit()
	set_value(node.get(property))
	release_focus()
