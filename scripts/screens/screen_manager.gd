extends Node
## Screen/Area manager - handles transitions between 200+ game screens
## Autoloaded as ScreenManager

signal screen_loaded(screen_id: int)
signal screen_transition_started(from_id: int, to_id: int)
signal screen_transition_completed(screen_id: int)

# Current screen
var current_screen_id: int = 0
var current_screen_data = null  # ScreenData
var current_screen_node: Node2D = null

# Screen cache (to avoid reloading)
var screen_cache: Dictionary = {}
var max_cache_size: int = 10

# Spawned entities
var spawned_enemies: Array = []
var spawned_npcs: Array = []

func _ready() -> void:
	print("ScreenManager initialized")

func load_screen(screen_id: int) -> void:
	"""Load and display a specific screen"""
	if screen_id == current_screen_id:
		return
	
	var from_id = current_screen_id
	screen_transition_started.emit(from_id, screen_id)
	
	# Get screen data
	current_screen_data = DatabaseManager.get_screen(screen_id)
	if not current_screen_data:
		push_error("Screen not found: " + str(screen_id))
		return
	
	# Clear current screen
	_clear_current_screen()
	
	# Load new screen
	current_screen_id = screen_id
	_build_screen()
	
	# Mark as visited
	GameManager.visit_screen(screen_id)
	GameManager.current_screen = current_screen_data.screen_name
	GameManager.current_area_id = screen_id
	
	screen_loaded.emit(screen_id)
	screen_transition_completed.emit(screen_id)
	
	print("Loaded screen: ", current_screen_data.screen_name)

func _clear_current_screen() -> void:
	"""Clear all entities from current screen"""
	# Despawn enemies
	for enemy in spawned_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	spawned_enemies.clear()
	
	# Despawn NPCs
	for npc in spawned_npcs:
		if is_instance_valid(npc):
			npc.queue_free()
	spawned_npcs.clear()
	
	# Remove screen node
	if current_screen_node and is_instance_valid(current_screen_node):
		current_screen_node.queue_free()
		current_screen_node = null

func _build_screen() -> void:
	"""Build the screen from data"""
	if not current_screen_data:
		return
	
	# Create screen node
	current_screen_node = Node2D.new()
	current_screen_node.name = "Screen_" + str(current_screen_id)
	get_tree().current_scene.add_child(current_screen_node)
	
	# Add background
	_add_background()
	
	# Add parallax layers
	_add_parallax_layers()
	
	# Spawn enemies
	_spawn_enemies()
	
	# Spawn NPCs
	_spawn_npcs()
	
	# Add portals
	_add_portals()
	
	# Set music
	_set_ambient_audio()

func _add_background() -> void:
	"""Add background image to screen"""
	if not current_screen_data.background_texture:
		return
	
	var bg_sprite = Sprite2D.new()
	bg_sprite.texture = current_screen_data.background_texture
	bg_sprite.scale = current_screen_data.background_scale
	bg_sprite.z_index = -100
	current_screen_node.add_child(bg_sprite)

func _add_parallax_layers() -> void:
	"""Add parallax background layers"""
	# TODO: Implement parallax layers
	pass

func _spawn_enemies() -> void:
	"""Spawn enemies defined in screen data"""
	if not current_screen_data.enemy_spawns:
		return
	
	for spawn_data in current_screen_data.enemy_spawns:
		var enemy_id = spawn_data.get("enemy_id", "")
		var position = spawn_data.get("position", Vector2.ZERO)
		
		var enemy = _create_enemy(enemy_id, position)
		if enemy:
			spawned_enemies.append(enemy)

func _spawn_npcs() -> void:
	"""Spawn NPCs defined in screen data"""
	if not current_screen_data.npc_spawns:
		return
	
	for spawn_data in current_screen_data.npc_spawns:
		var npc_id = spawn_data.get("npc_id", "")
		var position = spawn_data.get("position", Vector2.ZERO)
		
		var npc = _create_enemy(npc_id, position)
		if npc:
			spawned_npcs.append(npc)

func _create_enemy(enemy_id: String, position: Vector2) -> Enemy:
	"""Create an enemy or NPC instance"""
	var enemy_data = DatabaseManager.get_enemy(enemy_id)
	if not enemy_data:
		return null
	
	# TODO: Load actual enemy scene
	var enemy = Enemy.new()
	enemy.initialize(enemy_data)
	enemy.global_position = position
	current_screen_node.add_child(enemy)
	
	return enemy

func _add_portals() -> void:
	"""Add portal objects to screen"""
	# TODO: Implement portal system
	pass

func _set_ambient_audio() -> void:
	"""Set ambient music and sounds for screen"""
	# TODO: Implement audio system
	pass

func transition_to_screen(direction: String) -> void:
	"""Transition to connected screen in given direction"""
	var target_screen_id = -1
	
	match direction:
		"left":
			target_screen_id = current_screen_data.connected_left
		"right":
			target_screen_id = current_screen_data.connected_right
		"up":
			target_screen_id = current_screen_data.connected_up
		"down":
			target_screen_id = current_screen_data.connected_down
	
	if target_screen_id >= 0:
		load_screen(target_screen_id)

func is_at_screen_boundary(position: Vector2, direction: String) -> bool:
	"""Check if position is at screen boundary in given direction"""
	if not current_screen_data:
		return false
	
	match direction:
		"left":
			return position.x <= current_screen_data.bounds_left
		"right":
			return position.x >= current_screen_data.bounds_right
	
	return false

func get_spawn_position(direction: String) -> Vector2:
	"""Get spawn position when entering from a direction"""
	if not current_screen_data:
		return Vector2.ZERO
	
	match direction:
		"left":
			return Vector2(current_screen_data.bounds_left + 100, current_screen_data.ground_level)
		"right":
			return Vector2(current_screen_data.bounds_right - 100, current_screen_data.ground_level)
	
	return Vector2.ZERO
