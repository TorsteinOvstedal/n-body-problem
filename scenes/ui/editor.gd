extends Control

signal play
signal pause
signal reset

@onready var entries   := $entries

@onready var inspector := $inspector

@onready var playback  := $sim_controls
@onready var reset_btn := $sim_controls/reset_btn
@onready var run_btn   := $sim_controls/run_btn

func _ready() -> void:
	reset_btn.pressed.connect(_on_reset_pressed)
	run_btn.connect("state0_pressed", _on_run_pressed)
	run_btn.connect("state1_pressed", _on_pause_pressed)
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)

var focused = null

func _on_gui_focus_changed(node: Control):
	focused = node

func _unhandled_key_input(event):
	# Alternative way to toggle start / pause.
	if event.is_action_pressed("ui_select"):
		run_btn.toggle()
	
	# Release focused input field.
	elif  event.is_action_pressed("ui_cancel") and focused:
		focused.release_focus()

	# Show / hide editor / editor components.
	elif event.is_action_pressed("toggle_editor"):
		visible = not visible
	
	elif event.is_action_pressed("toggle_overview"):
		entries.visible = not entries.visible
	
	elif event.is_action_pressed("toggle_inspector"):
		inspector.visible = not inspector.visible
	
	elif event.is_action_pressed("toggle_controls"):
		playback.visible = not playback.visible

func _on_reset_pressed() -> void:
	reset.emit()

func _on_run_pressed() -> void:
	play.emit()

func _on_pause_pressed() -> void:
	pause.emit()
