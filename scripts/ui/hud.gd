extends CanvasLayer
class_name HUD
## Main HUD overlay - displays health, mana, energy, minimap, etc.

# Health bar
@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/HealthBar/Label

# Mana bar
@onready var mana_bar: ProgressBar = $MarginContainer/VBoxContainer/ManaBar
@onready var mana_label: Label = $MarginContainer/VBoxContainer/ManaBar/Label

# Energy bar
@onready var energy_bar: ProgressBar = $MarginContainer/VBoxContainer/EnergyBar
@onready var energy_label: Label = $MarginContainer/VBoxContainer/EnergyBar/Label

# Experience bar
@onready var exp_bar: ProgressBar = $MarginContainer/VBoxContainer/ExpBar
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel

# Gold display
@onready var gold_label: Label = $MarginContainer/VBoxContainer/GoldLabel

# Quest tracker
@onready var quest_tracker: VBoxContainer = $QuestTracker

func _ready() -> void:
	# Connect to player signals
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(_on_health_changed)
		player.mana_changed.connect(_on_mana_changed)
		player.energy_changed.connect(_on_energy_changed)
	
	# Connect to game manager signals
	GameManager.level_changed.connect(_on_level_changed)
	GameManager.gold_changed.connect(_on_gold_changed)
	
	# Connect to quest manager signals
	QuestManager.quest_started.connect(_on_quest_started)
	QuestManager.quest_updated.connect(_on_quest_updated)
	QuestManager.quest_completed.connect(_on_quest_completed)
	
	# Initialize displays
	_update_level_display()
	_update_gold_display()
	_update_quest_tracker()

func _on_health_changed(current: float, maximum: float) -> void:
	"""Update health bar"""
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current
	if health_label:
		health_label.text = str(int(current)) + " / " + str(int(maximum))

func _on_mana_changed(current: float, maximum: float) -> void:
	"""Update mana bar"""
	if mana_bar:
		mana_bar.max_value = maximum
		mana_bar.value = current
	if mana_label:
		mana_label.text = str(int(current)) + " / " + str(int(maximum))

func _on_energy_changed(current: float, maximum: float) -> void:
	"""Update energy bar"""
	if energy_bar:
		energy_bar.max_value = maximum
		energy_bar.value = current
	if energy_label:
		energy_label.text = str(int(current)) + " / " + str(int(maximum))

func _on_level_changed(new_level: int) -> void:
	"""Update level display"""
	_update_level_display()
	_update_experience_display()

func _on_gold_changed(new_amount: int) -> void:
	"""Update gold display"""
	_update_gold_display()

func _update_level_display() -> void:
	"""Update level label"""
	if level_label:
		level_label.text = "Level " + str(GameManager.player_level)

func _update_experience_display() -> void:
	"""Update experience bar"""
	if exp_bar:
		var exp_needed = GameManager.get_exp_for_next_level()
		exp_bar.max_value = exp_needed
		exp_bar.value = GameManager.player_experience

func _update_gold_display() -> void:
	"""Update gold label"""
	if gold_label:
		gold_label.text = "Gold: " + str(GameManager.player_gold)

func _update_quest_tracker() -> void:
	"""Update quest tracker display"""
	if not quest_tracker:
		return
	
	# Clear existing quest entries
	for child in quest_tracker.get_children():
		child.queue_free()
	
	# Add active quests
	var active_quests = QuestManager.get_active_quests()
	for quest in active_quests:
		var quest_entry = Label.new()
		quest_entry.text = quest.get("name", "Unknown Quest")
		# TODO: Add quest progress display
		quest_tracker.add_child(quest_entry)

func _on_quest_started(quest_id: String) -> void:
	"""Called when a quest is started"""
	_update_quest_tracker()

func _on_quest_updated(quest_id: String, progress: int) -> void:
	"""Called when quest progress updates"""
	_update_quest_tracker()

func _on_quest_completed(quest_id: String) -> void:
	"""Called when a quest is completed"""
	_update_quest_tracker()
	# TODO: Show quest completion notification
