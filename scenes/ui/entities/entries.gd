extends Panel

signal add_request
signal remove_request(entry: Entry)
signal select_request(entry: Entry)

const EntryInstance := preload("res://scenes/ui/entities/entry.tscn")

@onready
var entries := $scrollable/vbox

@onready
var add_btn := $add_btn

## Adds a new entry

func add_body(body: Body) -> Entry:
	var entry := EntryInstance.instantiate()
	entry.select_request.connect(_on_entry_select_request)
	entry.remove_request.connect(_on_entry_remove_request)
	entry.ref = body

	entries.add_child(entry)

	return entry
	
func get_entry(body: Body) -> Entry:
	for entry in entries.get_children():
		if entry.ref == body:
			return entry

	return null

## Removes the entry associated with the given body.

func remove_body(body: Body) -> void:
	for entry in entries.get_children():
		
		if entry.ref == body:
			entries.remove_child(entry)
			entry.call_deferred("queue_free")
			return

## Removes the entry.

func remove_entry(entry: Entry) -> void:
	entries.remove_child(entry)
	entry.call_deferred("queue_free")

func _ready() -> void:
	add_btn.pressed.connect(_on_add_request)

func _on_add_request() -> void:
	add_request.emit()

func _on_entry_remove_request(entry: Entry) -> void:
	remove_request.emit(entry)

func _on_entry_select_request(entry: Entry) -> void:
	select_request.emit(entry)
