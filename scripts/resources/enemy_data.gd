extends Resource
class_name EnemyData
## Data structure for enemy/NPC definitions

@export var enemy_id: String = ""
@export var enemy_name: String = ""
@export var is_npc: bool = false  # True if non-hostile NPC
@export var variant: String = ""  # small, medium, large, frost, etc.

# Visual
@export_group("Visual")
@export var sprite_frames: SpriteFrames
@export var scale_multiplier: float = 1.0
@export var tint_color: Color = Color.WHITE

# Stats
@export_group("Stats")
@export var level: int = 1
@export var health: int = 50
@export var attack_damage: int = 5
@export var defense: int = 2
@export var speed: float = 100.0
@export var aggro_range: float = 150.0

# Behavior
@export_group("Behavior")
@export var is_aggressive: bool = true
@export var patrol_range: float = 200.0
@export var chase_range: float = 400.0
@export var attack_range: float = 50.0
@export var attack_cooldown: float = 1.5

# Rewards
@export_group("Rewards")
@export var exp_reward: int = 10
@export var gold_min: int = 1
@export var gold_max: int = 5
@export var loot_table: Array[Dictionary] = []  # [{item_id, chance, min, max}, ...]

# Special abilities
@export var special_abilities: Array[String] = []

# Dialogue (for NPCs)
@export_group("NPC Dialogue")
@export var dialogue_lines: Array[String] = []
@export var quest_giver: bool = false
@export var vendor: bool = false
@export var vendor_inventory: Array[String] = []

func get_random_gold_drop() -> int:
	"""Get random gold amount within min/max range"""
	return randi_range(gold_min, gold_max)

func get_loot_drops() -> Array[Dictionary]:
	"""Roll loot table and return dropped items"""
	var drops: Array[Dictionary] = []
	
	for entry in loot_table:
		var chance = entry.get("chance", 0.0)
		if randf() <= chance:
			var item_id = entry.get("item_id", "")
			var amount = randi_range(entry.get("min", 1), entry.get("max", 1))
			drops.append({"item_id": item_id, "amount": amount})
	
	return drops
