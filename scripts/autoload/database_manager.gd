extends Node
## Database manager - handles all game data resources
## Autoloaded as DatabaseManager

# Player classes
var player_classes: Dictionary = {}  # class_id: PlayerClassData

# Enemies and NPCs
var enemies: Dictionary = {}  # enemy_id: EnemyData

# Screens/Areas
var screens: Dictionary = {}  # screen_id: ScreenData

# Items
var items: Dictionary = {}  # item_id: ItemData

# Quests
var quests: Dictionary = {}  # quest_id: QuestData

# Abilities/Skills
var abilities: Dictionary = {}  # ability_id: AbilityData

func _ready() -> void:
	print("DatabaseManager initialized")
	load_all_data()

func load_all_data() -> void:
	"""Load all game data resources"""
	_load_player_classes()
	_load_enemies()
	_load_screens()
	_load_items()
	_load_quests()
	_load_abilities()

func _load_player_classes() -> void:
	"""Load all player class definitions"""
	# TODO: Load from resources folder when created
	# For now, create placeholder data based on readme
	_create_default_classes()

func _create_default_classes() -> void:
	"""Create default player class data"""
	var class_names = [
		"Bandit", "Death Knight", "Enchanter", "Engineer",
		"Golem", "Hero", "Huntsman", "Mage",
		"Monk", "Lich", "Paladin", "Tribalist"
	]
	
	for i in range(class_names.size()):
		var class_id = class_names[i].to_lower().replace(" ", "_")
		var class_data = PlayerClassData.new()
		class_data.class_id = class_id
		class_data.class_name = class_names[i]
		class_data.description = "A " + class_names[i] + " class"
		
		# Set basic stats (can be customized per class)
		class_data.base_health = 100
		class_data.base_mana = 50
		class_data.base_energy = 100
		class_data.base_attack = 10
		class_data.base_defense = 5
		class_data.base_speed = 5
		
		# Class-specific bonuses from readme
		match class_id:
			"bandit":
				class_data.bonus_stat_type = "gold_gain"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% gold gain & +1% attack speed per level"
			"death_knight":
				class_data.bonus_stat_type = "harm_touch_damage"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% harm touch damage per level"
			"enchanter":
				class_data.bonus_stat_type = "vendor_discount"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% discount from vendors per level"
			"engineer":
				class_data.bonus_stat_type = "xp_gain"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% XP gain per level"
			"golem":
				class_data.bonus_stat_type = "armor"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% armor per level"
			"hero":
				class_data.bonus_stat_type = "damage"
				class_data.bonus_per_level = 1.5
				class_data.bonus_description = "+1.5% damage per level"
			"huntsman":
				class_data.bonus_stat_type = "crit_damage"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% crit damage per level"
			"mage":
				class_data.bonus_stat_type = "mana"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% mana per level"
			"monk":
				class_data.bonus_stat_type = "willpower"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% willpower per level"
			"lich":
				class_data.bonus_stat_type = "poison_disease_damage"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% poison & disease damage per level"
			"paladin":
				class_data.bonus_stat_type = "healing_aura"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% healing aura per level"
			"tribalist":
				class_data.bonus_stat_type = "crit_chance"
				class_data.bonus_per_level = 1.0
				class_data.bonus_description = "+1% crit chance per level"
		
		player_classes[class_id] = class_data
	
	print("Loaded ", player_classes.size(), " player classes")

func _load_enemies() -> void:
	"""Load all enemy definitions"""
	# TODO: Load from resources folder
	_create_default_enemies()

func _create_default_enemies() -> void:
	"""Create default enemy data based on readme"""
	var enemy_types = [
		{"name": "Bandit", "variants": ["normal"]},
		{"name": "Bear", "variants": ["cub", "medium", "large"]},
		{"name": "Bear Frost", "variants": ["cub", "medium", "large"]},
		{"name": "Dinosaur", "variants": ["medium", "large"]},
		{"name": "Dragon", "variants": ["dragonling", "normal"]},
		{"name": "Dragon Turtle", "variants": ["normal"]},
		{"name": "Elemental", "variants": ["fire", "earth", "air"]},
		{"name": "Ghost", "variants": ["normal"]},
		{"name": "Giant", "variants": ["normal"]},
		{"name": "Goblin", "variants": ["whelp", "normal"]},
		{"name": "Lizard", "variants": ["hatchling", "medium", "large"]},
		{"name": "Rat", "variants": ["small", "medium", "large"]},
		{"name": "Scorpion", "variants": ["normal", "large"]},
		{"name": "Siren", "variants": ["normal"]},
		{"name": "Snake", "variants": ["small", "medium", "large"]},
		{"name": "Spider", "variants": ["spiderling", "medium", "large"]},
		{"name": "Spider Frost", "variants": ["normal"]},
		{"name": "Vampire", "variants": ["normal"]},
		{"name": "Wasp", "variants": ["medium", "large"]},
		{"name": "Werewolf", "variants": ["normal"]},
		{"name": "Wolf", "variants": ["pup", "medium", "large"]},
		{"name": "Zombie", "variants": ["normal"]},
	]
	
	for enemy_type in enemy_types:
		for variant in enemy_type["variants"]:
			var enemy_id = (enemy_type["name"] + "_" + variant).to_lower().replace(" ", "_")
			var enemy_data = EnemyData.new()
			enemy_data.enemy_id = enemy_id
			enemy_data.enemy_name = enemy_type["name"] + " (" + variant + ")"
			enemy_data.variant = variant
			enemy_data.is_npc = false
			
			# Scale stats based on variant
			var scale_factor = 1.0
			match variant:
				"cub", "pup", "hatchling", "spiderling", "whelp", "small", "dragonling":
					scale_factor = 0.5
				"medium", "normal":
					scale_factor = 1.0
				"large":
					scale_factor = 2.0
			
			enemy_data.health = int(50 * scale_factor)
			enemy_data.attack_damage = int(5 * scale_factor)
			enemy_data.defense = int(2 * scale_factor)
			enemy_data.exp_reward = int(10 * scale_factor)
			enemy_data.gold_min = int(1 * scale_factor)
			enemy_data.gold_max = int(5 * scale_factor)
			
			enemies[enemy_id] = enemy_data
			
			# Also create NPC variant
			var npc_id = enemy_id + "_npc"
			var npc_data = EnemyData.new()
			npc_data.enemy_id = npc_id
			npc_data.enemy_name = enemy_type["name"] + " NPC"
			npc_data.is_npc = true
			npc_data.is_aggressive = false
			npc_data.health = enemy_data.health
			enemies[npc_id] = npc_data
	
	print("Loaded ", enemies.size(), " enemies/NPCs")

func _load_screens() -> void:
	"""Load all screen/area definitions"""
	# TODO: Load from resources folder
	# For now, create placeholder structure for 200 screens
	for i in range(200):
		var screen_data = ScreenData.new()
		screen_data.screen_id = i
		screen_data.screen_name = "Area " + str(i)
		screens[i] = screen_data
	
	print("Loaded ", screens.size(), " screens")

func _load_items() -> void:
	"""Load all item definitions"""
	# TODO: Implement item system
	print("Item loading not yet implemented")

func _load_quests() -> void:
	"""Load all quest definitions"""
	# TODO: Implement quest loading
	print("Quest loading not yet implemented")

func _load_abilities() -> void:
	"""Load all ability/skill definitions"""
	# TODO: Implement ability loading
	print("Ability loading not yet implemented")

# Getter functions
func get_player_class(class_id: String) -> PlayerClassData:
	"""Get player class data by ID"""
	return player_classes.get(class_id, null)

func get_enemy(enemy_id: String) -> EnemyData:
	"""Get enemy data by ID"""
	return enemies.get(enemy_id, null)

func get_screen(screen_id: int) -> ScreenData:
	"""Get screen data by ID"""
	return screens.get(screen_id, null)

func get_all_player_classes() -> Array:
	"""Get array of all player class data"""
	return player_classes.values()

func get_all_enemies() -> Array:
	"""Get array of all enemy data"""
	return enemies.values()

func get_npcs_only() -> Array:
	"""Get array of only NPC data (non-hostile)"""
	var npcs = []
	for enemy in enemies.values():
		if enemy.is_npc:
			npcs.append(enemy)
	return npcs

func get_hostiles_only() -> Array:
	"""Get array of only hostile enemy data"""
	var hostiles = []
	for enemy in enemies.values():
		if not enemy.is_npc:
			hostiles.append(enemy)
	return hostiles
