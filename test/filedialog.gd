extends Control

var dialog = FileDialog.new()

func _ready() -> void:
	dialog = FileDialog.new()
	add_child(dialog)

func _unhandled_input(event):
	if Input.is_action_just_pressed("save"):
		dialog.popup_centered(Vector2(640, 480))
