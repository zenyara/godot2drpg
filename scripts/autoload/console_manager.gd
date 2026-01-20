extends Node
## Developer console system - commands and cheats
## Autoloaded as ConsoleManager

signal console_toggled(visible: bool)
signal command_executed(command: String, result: String)

var console_visible: bool = false
var command_history: Array[String] = []
var max_history: int = 50

# Command registry
var commands: Dictionary = {
	"die": {"func": cmd_die, "description": "Kill your player character"},
	"exit": {"func": cmd_exit, "description": "Quit game"},
	"fly": {"func": cmd_fly, "description": "Move around freely (toggle)"},
	"give": {"func": cmd_give, "description": "Give item to self (give item_id amount)"},
	"god": {"func": cmd_god, "description": "Toggle invincibility"},
	"idea": {"func": cmd_idea, "description": "Add a note/idea"},
	"note": {"func": cmd_note, "description": "Add a note/idea"},
	"kill": {"func": cmd_kill, "description": "Kill targeted NPC"},
	"killall": {"func": cmd_killall, "description": "Kill all nearby NPCs (not self)"},
	"spawn": {"func": cmd_spawn, "description": "Spawn entity (spawn enemy_id)"},
	"teleport": {"func": cmd_teleport, "description": "Teleport to screen (teleport screen_id)"},
	"warp": {"func": cmd_teleport, "description": "Teleport to screen (warp screen_id)"},
	"help": {"func": cmd_help, "description": "List all commands"},
	"clear": {"func": cmd_clear, "description": "Clear console output"},
	"addgold": {"func": cmd_add_gold, "description": "Add gold (addgold amount)"},
	"addexp": {"func": cmd_add_exp, "description": "Add experience (addexp amount)"},
	"setlevel": {"func": cmd_set_level, "description": "Set player level (setlevel level)"},
}

# Console state
var god_mode: bool = false
var fly_mode: bool = false
var notes: Array[String] = []

func _ready() -> void:
	print("ConsoleManager initialized")
	print("Press ` (backtick) to open console")

func _input(event: InputEvent) -> void:
	# Toggle console with backtick key
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_QUOTELEFT:  # Backtick key
			toggle_console()

func toggle_console() -> void:
	"""Toggle console visibility"""
	console_visible = !console_visible
	console_toggled.emit(console_visible)

func execute_command(input: String) -> String:
	"""Parse and execute a console command"""
	if input.is_empty():
		return ""
	
	# Add to history
	command_history.append(input)
	if command_history.size() > max_history:
		command_history.pop_front()
	
	# Parse command and arguments
	var parts = input.split(" ", false)
	if parts.is_empty():
		return ""
	
	var cmd = parts[0].to_lower()
	var args = parts.slice(1)
	
	# Execute command
	if cmd in commands:
		var result = commands[cmd]["func"].call(args)
		command_executed.emit(input, result)
		return result
	else:
		var error = "Unknown command: " + cmd + ". Type 'help' for list of commands."
		command_executed.emit(input, error)
		return error

# ===== COMMAND IMPLEMENTATIONS =====

func cmd_help(args: Array) -> String:
	"""List all available commands"""
	var output = "Available commands:\n"
	for cmd_name in commands.keys():
		output += "  " + cmd_name + " - " + commands[cmd_name]["description"] + "\n"
	return output

func cmd_clear(args: Array) -> String:
	"""Clear console output"""
	return "[CLEAR]"  # Special signal to UI to clear

func cmd_die(args: Array) -> String:
	"""Kill player character"""
	if GameManager.has_method("kill_player"):
		GameManager.kill_player()
		return "Player killed."
	return "Cannot kill player (method not implemented yet)."

func cmd_exit(args: Array) -> String:
	"""Quit the game"""
	get_tree().quit()
	return "Exiting game..."

func cmd_fly(args: Array) -> String:
	"""Toggle fly mode"""
	fly_mode = !fly_mode
	# Signal to player controller
	return "Fly mode: " + ("ON" if fly_mode else "OFF")

func cmd_god(args: Array) -> String:
	"""Toggle god mode (invincibility)"""
	god_mode = !god_mode
	return "God mode: " + ("ON" if god_mode else "OFF")

func cmd_give(args: Array) -> String:
	"""Give item to player"""
	if args.size() < 1:
		return "Usage: give <item_id> [amount]"
	
	var item_id = args[0]
	var amount = 1
	if args.size() >= 2:
		amount = args[1].to_int()
	
	if InventoryManager.add_item(item_id, amount):
		return "Added " + str(amount) + "x " + item_id + " to inventory."
	else:
		return "Failed to add item (inventory full?)."

func cmd_idea(args: Array) -> String:
	"""Add a note/idea"""
	if args.is_empty():
		return "Usage: idea <your note here>"
	
	var note = " ".join(args)
	notes.append(note)
	_save_notes()
	return "Note added: " + note

func cmd_note(args: Array) -> String:
	"""Alias for idea command"""
	return cmd_idea(args)

func cmd_kill(args: Array) -> String:
	"""Kill targeted NPC"""
	# TODO: Implement when we have targeting system
	return "Kill command not yet implemented (need targeting system)."

func cmd_killall(args: Array) -> String:
	"""Kill all nearby NPCs"""
	# TODO: Implement when we have enemy system
	return "Killall command not yet implemented (need enemy system)."

func cmd_spawn(args: Array) -> String:
	"""Spawn an enemy or NPC"""
	if args.is_empty():
		return "Usage: spawn <enemy_id>"
	
	var enemy_id = args[0]
	# TODO: Implement spawning system
	return "Spawn command not yet implemented. Would spawn: " + enemy_id

func cmd_teleport(args: Array) -> String:
	"""Teleport to a screen"""
	if args.is_empty():
		return "Usage: teleport <screen_id>"
	
	var screen_id = args[0].to_int()
	# TODO: Implement screen manager teleport
	return "Teleport command not yet implemented. Would teleport to screen: " + str(screen_id)

func cmd_add_gold(args: Array) -> String:
	"""Add gold to player"""
	if args.is_empty():
		return "Usage: addgold <amount>"
	
	var amount = args[0].to_int()
	GameManager.add_gold(amount)
	return "Added " + str(amount) + " gold. Total: " + str(GameManager.player_gold)

func cmd_add_exp(args: Array) -> String:
	"""Add experience to player"""
	if args.is_empty():
		return "Usage: addexp <amount>"
	
	var amount = args[0].to_int()
	GameManager.add_experience(amount)
	return "Added " + str(amount) + " experience."

func cmd_set_level(args: Array) -> String:
	"""Set player level"""
	if args.is_empty():
		return "Usage: setlevel <level>"
	
	var level = args[0].to_int()
	GameManager.player_level = level
	GameManager.level_changed.emit(level)
	return "Player level set to " + str(level)

func _save_notes() -> void:
	"""Save notes to file"""
	var file = FileAccess.open("user://notes.txt", FileAccess.WRITE)
	if file:
		for note in notes:
			file.store_line(note)
		file.close()

func _load_notes() -> void:
	"""Load notes from file"""
	if FileAccess.file_exists("user://notes.txt"):
		var file = FileAccess.open("user://notes.txt", FileAccess.READ)
		if file:
			while not file.eof_reached():
				var line = file.get_line()
				if not line.is_empty():
					notes.append(line)
			file.close()

func is_god_mode() -> bool:
	"""Check if god mode is active"""
	return god_mode

func is_fly_mode() -> bool:
	"""Check if fly mode is active"""
	return fly_mode
