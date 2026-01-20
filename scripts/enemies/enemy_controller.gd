extends CharacterBody2D
class_name Enemy
## Base enemy/NPC controller

# References
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var detection_area: Area2D = $DetectionArea

# Enemy data
var enemy_data: EnemyData = null
var enemy_id: String = ""

# Stats
var max_health: float = 50.0
var current_health: float = 50.0
var attack_damage: float = 5.0
var defense: float = 2.0
var move_speed: float = 100.0

# State
enum State { IDLE, PATROL, CHASE, ATTACK, FLEE, DEAD }
var current_state: State = State.IDLE
var is_npc: bool = false
var is_aggressive: bool = true

# Combat
var target: Node2D = null
var attack_cooldown: float = 0.0
var attack_timer: float = 0.0

# Movement
var patrol_origin: Vector2 = Vector2.ZERO
var patrol_target: Vector2 = Vector2.ZERO
var facing_right: bool = true

# Loot
var has_been_looted: bool = false

signal died(enemy: Enemy)
signal loot_dropped(items: Array, gold: int)

func _ready() -> void:
	patrol_origin = global_position
	_choose_new_patrol_point()
	
	if detection_area:
		detection_area.body_entered.connect(_on_detection_area_entered)
		detection_area.body_exited.connect(_on_detection_area_exited)

func initialize(data: EnemyData) -> void:
	"""Initialize enemy with data"""
	enemy_data = data
	enemy_id = data.enemy_id
	is_npc = data.is_npc
	is_aggressive = data.is_aggressive
	
	# Apply stats
	max_health = data.health
	current_health = max_health
	attack_damage = data.attack_damage
	defense = data.defense
	move_speed = data.speed
	
	# Apply visual
	if sprite and data.sprite_frames:
		sprite.sprite_frames = data.sprite_frames
	
	if data.scale_multiplier != 1.0:
		scale = Vector2.ONE * data.scale_multiplier
	
	if data.tint_color != Color.WHITE:
		sprite.modulate = data.tint_color
	
	# Set up detection range
	if detection_area:
		var shape = CircleShape2D.new()
		shape.radius = data.aggro_range
		detection_area.get_child(0).shape = shape

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	_update_state(delta)
	_update_movement(delta)
	_update_animation()

func _update_state(delta: float) -> void:
	"""Update AI state machine"""
	match current_state:
		State.IDLE:
			if is_aggressive and target:
				current_state = State.CHASE
			elif not is_npc:
				# Random chance to start patrolling
				if randf() < 0.01:
					current_state = State.PATROL
		
		State.PATROL:
			if is_aggressive and target:
				current_state = State.CHASE
			elif global_position.distance_to(patrol_target) < 10.0:
				_choose_new_patrol_point()
		
		State.CHASE:
			if not target or not is_instance_valid(target):
				target = null
				current_state = State.IDLE
			elif global_position.distance_to(target.global_position) <= enemy_data.attack_range:
				current_state = State.ATTACK
			elif global_position.distance_to(patrol_origin) > enemy_data.chase_range:
				# Too far from origin, return
				target = null
				current_state = State.IDLE
		
		State.ATTACK:
			if not target or not is_instance_valid(target):
				target = null
				current_state = State.IDLE
			elif global_position.distance_to(target.global_position) > enemy_data.attack_range:
				current_state = State.CHASE
			else:
				_attempt_attack(delta)

func _update_movement(delta: float) -> void:
	"""Update movement based on state"""
	velocity = Vector2.ZERO
	
	match current_state:
		State.PATROL:
			var direction = (patrol_target - global_position).normalized()
			velocity = direction * move_speed * 0.5  # Slower when patrolling
		
		State.CHASE:
			if target:
				var direction = (target.global_position - global_position).normalized()
				velocity = direction * move_speed
		
		State.ATTACK:
			# Stop moving when attacking
			velocity = Vector2.ZERO
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += 980.0 * delta
	
	move_and_slide()
	
	# Update facing direction
	if velocity.x > 0:
		facing_right = true
		sprite.flip_h = false
	elif velocity.x < 0:
		facing_right = false
		sprite.flip_h = true

func _update_animation() -> void:
	"""Update sprite animation"""
	if not sprite or not sprite.sprite_frames:
		return
	
	match current_state:
		State.IDLE:
			if sprite.sprite_frames.has_animation("idle"):
				sprite.play("idle")
		State.PATROL, State.CHASE:
			if sprite.sprite_frames.has_animation("walk"):
				sprite.play("walk")
		State.ATTACK:
			if sprite.sprite_frames.has_animation("attack"):
				sprite.play("attack")
		State.DEAD:
			if sprite.sprite_frames.has_animation("death"):
				sprite.play("death")

func _choose_new_patrol_point() -> void:
	"""Choose a random patrol destination"""
	if not enemy_data:
		return
	
	var angle = randf() * TAU
	var distance = randf() * enemy_data.patrol_range
	patrol_target = patrol_origin + Vector2(cos(angle), sin(angle)) * distance

func _attempt_attack(delta: float) -> void:
	"""Try to attack the target"""
	attack_timer += delta
	
	if attack_timer >= enemy_data.attack_cooldown:
		attack_timer = 0.0
		_perform_attack()

func _perform_attack() -> void:
	"""Execute an attack on the target"""
	if not target or not is_instance_valid(target):
		return
	
	if target.has_method("take_damage"):
		target.take_damage(attack_damage, self)

func take_damage(damage: float, source: Node = null) -> void:
	"""Take damage from an attack"""
	if current_state == State.DEAD:
		return
	
	var actual_damage = max(1.0, damage - defense)
	current_health -= actual_damage
	
	# Become aggressive toward attacker
	if source and is_instance_valid(source):
		target = source
		if current_state != State.ATTACK:
			current_state = State.CHASE
	
	# Check for death
	if current_health <= 0:
		die()

func die() -> void:
	"""Handle enemy death"""
	if current_state == State.DEAD:
		return
	
	current_state = State.DEAD
	current_health = 0
	
	# Disable collision
	collision.set_deferred("disabled", true)
	
	# Give experience and gold to player
	GameManager.add_experience(enemy_data.exp_reward)
	var gold_drop = enemy_data.get_random_gold_drop()
	GameManager.add_gold(gold_drop)
	
	# Drop loot
	var loot = enemy_data.get_loot_drops()
	for item in loot:
		InventoryManager.add_item(item["item_id"], item["amount"])
	
	loot_dropped.emit(loot, gold_drop)
	died.emit(self)
	
	# Notify quest system
	QuestManager.on_enemy_killed(enemy_id)
	
	# Remove after delay
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_detection_area_entered(body: Node2D) -> void:
	"""Detect player entering range"""
	if body is Player and is_aggressive:
		target = body

func _on_detection_area_exited(body: Node2D) -> void:
	"""Detect player leaving range"""
	if body == target:
		# Don't immediately lose target, will be handled by chase range check
		pass

func interact() -> void:
	"""Called when player interacts with NPC"""
	if is_npc and enemy_data:
		# Show dialogue
		if enemy_data.dialogue_lines.size() > 0:
			var random_line = enemy_data.dialogue_lines[randi() % enemy_data.dialogue_lines.size()]
			print(enemy_data.enemy_name, ": ", random_line)
		
		# Check if quest giver
		if enemy_data.quest_giver:
			# TODO: Show quest dialogue
			pass
		
		# Check if vendor
		if enemy_data.vendor:
			# TODO: Open vendor shop
			pass
