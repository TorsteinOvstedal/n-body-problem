class_name Entry

extends Control

signal remove_request(entry: Entry)
signal select_request(entry: Entry)

var ref: Body

@onready
var remove_btn := $remove_btn

@onready
var select_btn := $select_btn

# Assume proper initialization before added to the scene tree.

func _ready() -> void:
	assert(ref != null, "INVALID STATE. Missing Body reference.")
	
	remove_btn.pressed.connect(_on_remove_btn_pressed)
	select_btn.pressed.connect(_on_select_btn_pressed)
	
	select_btn.text = ref.physics.name

func _on_remove_btn_pressed() -> void:
	remove_request.emit(self)
	
func _on_select_btn_pressed() -> void:
	select_request.emit(self)
