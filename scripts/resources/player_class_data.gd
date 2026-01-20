extends Resource
class_name PlayerClassData
## Data structure for player class definitions

@export var class_id: String = ""
@export var display_name: String = ""
@export var description: String = ""
@export var icon: Texture2D

# Base stats
@export_group("Base Stats")
@export var base_health: int = 100
@export var base_mana: int = 100
@export var base_energy: int = 100
@export var base_attack: int = 10
@export var base_defense: int = 5
@export var base_speed: int = 5

# Stat growth per level
@export_group("Stat Growth")
@export var health_per_level: int = 10
@export var mana_per_level: int = 5
@export var energy_per_level: int = 5
@export var attack_per_level: float = 1.0
@export var defense_per_level: float = 0.5
@export var speed_per_level: float = 0.5

# Class-specific bonuses
@export_group("Class Bonuses")
@export var bonus_stat_type: String = ""  # gold_gain, xp_gain, attack_speed, etc.
@export var bonus_per_level: float = 1.0  # Percentage increase per level
@export var bonus_description: String = ""

# Available abilities
@export var starting_abilities: Array = []

# Starting equipment
@export var starting_weapon: String = ""
@export var starting_armor: String = ""

func get_stat_at_level(stat_name: String, level: int) -> float:
	"""Calculate stat value at given level"""
	match stat_name:
		"health":
			return base_health + (health_per_level * (level - 1))
		"mana":
			return base_mana + (mana_per_level * (level - 1))
		"energy":
			return base_energy + (energy_per_level * (level - 1))
		"attack":
			return base_attack + (attack_per_level * (level - 1))
		"defense":
			return base_defense + (defense_per_level * (level - 1))
		"speed":
			return base_speed + (speed_per_level * (level - 1))
		_:
			return 0.0

func get_class_bonus(level: int) -> float:
	"""Get class-specific bonus at given level"""
	return bonus_per_level * level
