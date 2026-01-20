extends CanvasLayer
class_name ConsoleUI
## Developer console UI

@onready var console_panel: Panel = $ConsolePanel
@onready var output_log: RichTextLabel = $ConsolePanel/VBoxContainer/OutputLog
@onready var input_field: LineEdit = $ConsolePanel/VBoxContainer/InputField

var command_history: Array = []
var history_index: int = -1

func _ready() -> void:
	# Hide console by default
	console_panel.visible = false
	
	# Connect to console manager
	ConsoleManager.console_toggled.connect(_on_console_toggled)
	ConsoleManager.command_executed.connect(_on_command_executed)
	
	# Connect input field
	input_field.text_submitted.connect(_on_input_submitted)

func _input(event: InputEvent) -> void:
	if not console_panel.visible:
		return
	
	# Navigate command history with up/down arrows
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			_navigate_history_up()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_DOWN:
			_navigate_history_down()
			get_viewport().set_input_as_handled()

func _on_console_toggled(visible: bool) -> void:
	"""Toggle console visibility"""
	console_panel.visible = visible
	
	if visible:
		input_field.grab_focus()
		input_field.clear()
	else:
		input_field.release_focus()

func _on_input_submitted(text: String) -> void:
	"""Execute command from input field"""
	if text.is_empty():
		return
	
	# Add to output
	_add_output("> " + text)
	
	# Execute command
	var result = ConsoleManager.execute_command(text)
	
	# Add result to command history
	command_history.append(text)
	history_index = command_history.size()
	
	# Clear input
	input_field.clear()

func _on_command_executed(command: String, result: String) -> void:
	"""Display command result"""
	if result == "[CLEAR]":
		output_log.clear()
	elif not result.is_empty():
		_add_output(result)

func _add_output(text: String) -> void:
	"""Add text to output log"""
	output_log.append_text(text + "\n")
	
	# Auto-scroll to bottom
	await get_tree().process_frame
	output_log.scroll_to_line(output_log.get_line_count())

func _navigate_history_up() -> void:
	"""Navigate up in command history"""
	if command_history.is_empty():
		return
	
	if history_index > 0:
		history_index -= 1
		input_field.text = command_history[history_index]
		input_field.caret_column = input_field.text.length()

func _navigate_history_down() -> void:
	"""Navigate down in command history"""
	if command_history.is_empty():
		return
	
	if history_index < command_history.size() - 1:
		history_index += 1
		input_field.text = command_history[history_index]
		input_field.caret_column = input_field.text.length()
	else:
		history_index = command_history.size()
		input_field.clear()
