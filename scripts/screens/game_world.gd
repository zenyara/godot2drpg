extends Node2D
## Main game world node - manages screen loading and transitions

@onready var player: Player = null

func _ready() -> void:
	# Find player
	player = get_tree().get_first_node_in_group("player")
	
	# Load initial screen
	ScreenManager.load_screen(0)

func _process(_delta: float) -> void:
	# Check for screen transitions
	_check_screen_boundaries()

func _check_screen_boundaries() -> void:
	"""Check if player is at screen edge and transition"""
	if not player:
		return
	
	var player_pos = player.global_position
	
	# Check right boundary
	if ScreenManager.is_at_screen_boundary(player_pos, "right"):
		if ScreenManager.current_screen_data and ScreenManager.current_screen_data.connected_right >= 0:
			ScreenManager.transition_to_screen("right")
			player.global_position = ScreenManager.get_spawn_position("left")
	
	# Check left boundary
	elif ScreenManager.is_at_screen_boundary(player_pos, "left"):
		if ScreenManager.current_screen_data and ScreenManager.current_screen_data.connected_left >= 0:
			ScreenManager.transition_to_screen("left")
			player.global_position = ScreenManager.get_spawn_position("right")
