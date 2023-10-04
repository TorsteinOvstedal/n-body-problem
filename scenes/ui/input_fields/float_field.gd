extends EditorInputField

var input: LineEdit

func is_valid() -> bool:
	return input.text.is_valid_float()

func get_value() -> float:
	return input.text.to_float()
	
func set_value(f: float) -> void:
	input.text = str(f)

func _ready():
	name_label  = $layout/name
	input = $layout/value
	
func _physics_process(_delta: float) -> void:
	if not bound():
		return
	
	var v = node.get(property)
	print(node.name, ".", property, " = ", v)
	if not input.has_focus():
		input.text = str(v)

func _on_changed(new_text: String) -> void:
	submit()

func _on_submitted(new_text: String) -> void:
	submit()
	set_value(node.get(property))
	input.release_focus()
