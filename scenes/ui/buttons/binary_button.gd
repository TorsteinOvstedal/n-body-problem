@tool

extends Button

signal state0_pressed

signal state1_pressed

@export_range(0, 1, 1)
var state: int      = 0 :    set = set_state

@export 
var text0: String   = "":   set = set_text0

@export 
var text1: String   = "":   set = set_text1

@export
var icon0: CompressedTexture2D = null: set = set_icon0

@export 
var icon1: CompressedTexture2D = null: set = set_icon1

# Bloat to update view in godot's editor.
func set_text0(new_text: String):
	text0 = new_text
	if state == 0:
		upload_state0()

func set_text1(new_text: String):
	text1 = new_text
	if state == 1:
		upload_state1()

func set_icon0(new_icon: CompressedTexture2D):
	icon0 = new_icon
	if state == 0:
		upload_state0()

func set_icon1(new_icon: CompressedTexture2D):
	icon1 = new_icon
	if state == 1:
		upload_state1()

func _ready():
	pressed.connect(_on_pressed)
	set_state(state)

func toggle() -> void:
	if  state == 0:
		state0_pressed.emit()
		set_state(1)

	else:
		state1_pressed.emit()
		set_state(0)

func upload_state0():
	text  = text0
	icon  = icon0

func upload_state1():
	text  = text1
	icon  = icon1

func set_state(new_state: int) -> void:
	state = new_state
	
	if state == 0:
		state = 0
		upload_state0()
	else:
		state = 1
		upload_state1()

func _on_pressed() -> void:
	toggle()
