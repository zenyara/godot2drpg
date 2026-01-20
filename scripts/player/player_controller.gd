extends CharacterBody2D
class_name Player
## Main player character controller

# References
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# Player stats (calculated from class + level + equipment)
var max_health: float = 100.0
var current_health: float = 100.0
var max_mana: float = 100.0
var current_mana: float = 100.0
var max_energy: float = 100.0
var current_energy: float = 100.0

var attack_power: float = 10.0
var defense: float = 5.0
var move_speed: float = 200.0
var attack_speed: float = 1.0  # Attacks per second

# State
var is_attacking: bool = false
var is_dead: bool = false
var can_move: bool = true
var facing_right: bool = true

# Combat
var attack_cooldown: float = 0.0
var invulnerable: bool = false
var invulnerable_timer: float = 0.0

# Class data
var player_class_data: PlayerClassData = null

# Input
var input_direction: Vector2 = Vector2.ZERO

signal health_changed(current: float, maximum: float)
signal mana_changed(current: float, maximum: float)
signal energy_changed(current: float, maximum: float)
signal player_died
signal attacked

func _ready() -> void:
	# Load player class and stats
	if not GameManager.player_class.is_empty():
		load_player_class(GameManager.player_class)
	
	# Initialize health/mana/energy to max
	current_health = max_health
	current_mana = max_mana
	current_energy = max_energy
	
	# Connect to game manager signals
	GameManager.level_changed.connect(_on_level_changed)

func load_player_class(class_id: String) -> void:
	"""Load player class data and apply stats"""
	player_class_data = DatabaseManager.get_player_class(class_id)
	
	if player_class_data:
		_calculate_stats()

func _calculate_stats() -> void:
	"""Calculate all stats based on class, level, and equipment"""
	if not player_class_data:
		return
	
	var level = GameManager.player_level
	
	# Base stats from class
	max_health = player_class_data.get_stat_at_level("health", level)
	max_mana = player_class_data.get_stat_at_level("mana", level)
	max_energy = player_class_data.get_stat_at_level("energy", level)
	attack_power = player_class_data.get_stat_at_level("attack", level)
	defense = player_class_data.get_stat_at_level("defense", level)
	move_speed = player_class_data.get_stat_at_level("speed", level) * 20.0  # Scale to pixels
	
	# Add equipment bonuses
	var equipment_stats = InventoryManager.get_equipped_stats()
	attack_power += equipment_stats.get("attack", 0)
	defense += equipment_stats.get("defense", 0)
	move_speed += equipment_stats.get("speed", 0)
	
	# Emit signals
	health_changed.emit(current_health, max_health)
	mana_changed.emit(current_mana, max_mana)
	energy_changed.emit(current_energy, max_energy)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Handle console fly mode
	if ConsoleManager.is_fly_mode():
		_handle_fly_mode(delta)
		return
	
	# Normal movement
	_handle_input()
	_handle_movement(delta)
	_handle_combat(delta)
	_update_animation()

func _handle_input() -> void:
	"""Get player input"""
	input_direction = Vector2.ZERO
	
	if can_move:
		if Input.is_action_pressed("move_right"):
			input_direction.x += 1
		if Input.is_action_pressed("move_left"):
			input_direction.x -= 1
		if Input.is_action_pressed("move_up"):
			input_direction.y -= 1
		if Input.is_action_pressed("move_down"):
			input_direction.y += 1
		
		input_direction = input_direction.normalized()
	
	# Attack input
	if Input.is_action_just_pressed("attack") and not is_attacking:
		_perform_attack()

func _handle_movement(delta: float) -> void:
	"""Handle player movement"""
	if can_move and not is_attacking:
		velocity = input_direction * move_speed
	else:
		velocity = velocity.lerp(Vector2.ZERO, 10.0 * delta)
	
	# Apply gravity if not on ground (for platforming)
	if not is_on_floor():
		velocity.y += 980.0 * delta
	
	move_and_slide()
	
	# Update facing direction
	if input_direction.x > 0:
		facing_right = true
		sprite.flip_h = false
	elif input_direction.x < 0:
		facing_right = false
		sprite.flip_h = true

func _handle_fly_mode(delta: float) -> void:
	"""Handle movement in fly mode (console cheat)"""
	_handle_input()
	velocity = input_direction * move_speed * 2.0  # Faster in fly mode
	move_and_slide()

func _handle_combat(delta: float) -> void:
	"""Handle combat timers"""
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	if invulnerable_timer > 0:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			invulnerable = false

func _update_animation() -> void:
	"""Update sprite animation based on state"""
	if is_dead:
		# Play death animation
		return
	
	if is_attacking:
		# Play attack animation
		return
	
	if velocity.length() > 10.0:
		# Play walk/run animation
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
			sprite.play("walk")
	else:
		# Play idle animation
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")

func _perform_attack() -> void:
	"""Execute an attack"""
	if attack_cooldown > 0:
		return
	
	is_attacking = true
	attack_cooldown = 1.0 / attack_speed
	attacked.emit()
	
	# TODO: Create attack hitbox and damage enemies
	
	# End attack after animation
	await get_tree().create_timer(0.3).timeout
	is_attacking = false

func take_damage(damage: float, source: Node = null) -> void:
	"""Take damage from an attack"""
	# Check god mode
	if ConsoleManager.is_god_mode():
		return
	
	if invulnerable or is_dead:
		return
	
	# Calculate actual damage after defense
	var actual_damage = max(1.0, damage - defense)
	current_health -= actual_damage
	
	health_changed.emit(current_health, max_health)
	
	# Become temporarily invulnerable
	invulnerable = true
	invulnerable_timer = 0.5
	
	# Check for death
	if current_health <= 0:
		die()

func heal(amount: float) -> void:
	"""Heal the player"""
	if is_dead:
		return
	
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func use_mana(amount: float) -> bool:
	"""Use mana for abilities, returns true if successful"""
	if current_mana >= amount:
		current_mana -= amount
		mana_changed.emit(current_mana, max_mana)
		return true
	return false

func restore_mana(amount: float) -> void:
	"""Restore mana"""
	current_mana = min(current_mana + amount, max_mana)
	mana_changed.emit(current_mana, max_mana)

func use_energy(amount: float) -> bool:
	"""Use energy for abilities, returns true if successful"""
	if current_energy >= amount:
		current_energy -= amount
		energy_changed.emit(current_energy, max_energy)
		return true
	return false

func restore_energy(amount: float) -> void:
	"""Restore energy"""
	current_energy = min(current_energy + amount, max_energy)
	energy_changed.emit(current_energy, max_energy)

func die() -> void:
	"""Handle player death"""
	if is_dead:
		return
	
	is_dead = true
	can_move = false
	current_health = 0
	
	health_changed.emit(current_health, max_health)
	player_died.emit()
	GameManager.player_died.emit()
	
	# TODO: Show death screen, respawn options

func respawn() -> void:
	"""Respawn the player"""
	is_dead = false
	can_move = true
	current_health = max_health
	current_mana = max_mana
	current_energy = max_energy
	
	health_changed.emit(current_health, max_health)
	mana_changed.emit(current_mana, max_mana)
	energy_changed.emit(current_energy, max_energy)

func _on_level_changed(new_level: int) -> void:
	"""Called when player levels up"""
	_calculate_stats()
	
	# Restore health/mana/energy on level up
	current_health = max_health
	current_mana = max_mana
	current_energy = max_energy
	
	health_changed.emit(current_health, max_health)
	mana_changed.emit(current_mana, max_mana)
	energy_changed.emit(current_energy, max_energy)
	
	print("Player leveled up to level ", new_level, "!")
