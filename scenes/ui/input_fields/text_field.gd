extends EditorInputField

var value_input: LineEdit

func _ready() -> void:
	name_label  = $layout/name
	value_input = $layout/value

func is_valid() -> bool:
	return true

func get_value() -> String:
	return value_input.text
	
func set_value(s: String) -> void:
	value_input.text = s

func _on_value_input_text_changed(new_text: String) -> void:
	value_changed.emit(new_text)

func _on_value_input_text_submitted(new_text: String) -> void:
	value_changed.emit(new_text)
	value_input.release_focus()
