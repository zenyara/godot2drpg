extends Node
## Central game manager - handles core game state and systems
## Autoloaded as GameManager

signal player_died
signal level_changed(new_level: int)
signal gold_changed(new_amount: int)

# Game state
var current_screen: String = ""
var current_area_id: int = 0
var game_paused: bool = false
var player_data: Dictionary = {}

# Player stats
var player_level: int = 1
var player_experience: int = 0
var player_gold: int = 0
var player_class: String = ""

# Game settings
var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0

# Screen/Area management
var visited_screens: Array = []
var unlocked_portals: Array = []

func _ready() -> void:
	print("GameManager initialized")
	process_mode = Node.PROCESS_MODE_ALWAYS  # Always process, even when paused

func start_new_game(player_class_name: String) -> void:
	"""Initialize a new game with selected player class"""
	player_class = player_class_name
	player_level = 1
	player_experience = 0
	player_gold = 0
	visited_screens.clear()
	unlocked_portals.clear()
	
	# Apply class-specific starting stats
	_apply_class_stats()
	
	print("New game started as: ", player_class)

func _apply_class_stats() -> void:
	"""Apply initial stats based on player class"""
	# This will be expanded with actual class data
	pass

func add_experience(amount: int) -> void:
	"""Add experience and check for level up"""
	player_experience += amount
	_check_level_up()

func _check_level_up() -> void:
	"""Check if player should level up"""
	var exp_needed = get_exp_for_next_level()
	while player_experience >= exp_needed:
		player_experience -= exp_needed
		player_level += 1
		level_changed.emit(player_level)
		exp_needed = get_exp_for_next_level()

func get_exp_for_next_level() -> int:
	"""Calculate experience needed for next level"""
	# Simple formula: 100 * level^1.5
	return int(100 * pow(player_level, 1.5))

func add_gold(amount: int) -> void:
	"""Add gold to player"""
	player_gold += amount
	gold_changed.emit(player_gold)

func remove_gold(amount: int) -> bool:
	"""Remove gold from player, returns true if successful"""
	if player_gold >= amount:
		player_gold -= amount
		gold_changed.emit(player_gold)
		return true
	return false

func visit_screen(screen_id: int) -> void:
	"""Mark a screen as visited"""
	if screen_id not in visited_screens:
		visited_screens.append(screen_id)

func unlock_portal(portal_name: String) -> void:
	"""Unlock a portal for fast travel"""
	if portal_name not in unlocked_portals:
		unlocked_portals.append(portal_name)

func pause_game() -> void:
	"""Pause the game"""
	game_paused = true
	get_tree().paused = true

func resume_game() -> void:
	"""Resume the game"""
	game_paused = false
	get_tree().paused = false

func save_game() -> void:
	"""Save game data to file"""
	var save_data = {
		"player_class": player_class,
		"player_level": player_level,
		"player_experience": player_experience,
		"player_gold": player_gold,
		"current_screen": current_screen,
		"current_area_id": current_area_id,
		"visited_screens": visited_screens,
		"unlocked_portals": unlocked_portals,
		"player_data": player_data,
	}
	
	var save_file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	if save_file:
		save_file.store_var(save_data)
		save_file.close()
		print("Game saved successfully")

func load_game() -> bool:
	"""Load game data from file"""
	if not FileAccess.file_exists("user://savegame.dat"):
		return false
	
	var save_file = FileAccess.open("user://savegame.dat", FileAccess.READ)
	if save_file:
		var save_data = save_file.get_var()
		save_file.close()
		
		player_class = save_data.get("player_class", "")
		player_level = save_data.get("player_level", 1)
		player_experience = save_data.get("player_experience", 0)
		player_gold = save_data.get("player_gold", 0)
		current_screen = save_data.get("current_screen", "")
		current_area_id = save_data.get("current_area_id", 0)
		visited_screens = save_data.get("visited_screens", [])
		unlocked_portals = save_data.get("unlocked_portals", [])
		player_data = save_data.get("player_data", {})
		
		print("Game loaded successfully")
		return true
	
	return false
