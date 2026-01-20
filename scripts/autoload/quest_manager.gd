extends Node
## Quest management system - tracks active quests and progression
## Autoloaded as QuestManager

signal quest_started(quest_id: String)
signal quest_updated(quest_id: String, progress: int)
signal quest_completed(quest_id: String)
signal quest_failed(quest_id: String)

# Quest tracking
var active_quests: Dictionary = {}  # quest_id: quest_data
var completed_quests: Array[String] = []
var failed_quests: Array[String] = []

# Quest data structure:
# {
#   "id": "quest_001",
#   "name": "Kill 10 Rats",
#   "description": "The village is infested with rats!",
#   "type": "kill",  # kill, collect, talk, explore, escort
#   "objectives": [
#     {"type": "kill", "target": "rat_small", "required": 10, "current": 0}
#   ],
#   "rewards": {
#     "exp": 100,
#     "gold": 50,
#     "items": []
#   },
#   "status": "active"  # active, completed, failed
# }

func _ready() -> void:
	print("QuestManager initialized")

func start_quest(quest_id: String, quest_data: Dictionary) -> void:
	"""Start a new quest"""
	if quest_id in active_quests:
		print("Quest already active: ", quest_id)
		return
	
	if quest_id in completed_quests:
		print("Quest already completed: ", quest_id)
		return
	
	quest_data["status"] = "active"
	active_quests[quest_id] = quest_data
	quest_started.emit(quest_id)
	print("Quest started: ", quest_data.get("name", quest_id))

func update_quest_progress(quest_id: String, objective_index: int, progress: int) -> void:
	"""Update progress on a quest objective"""
	if quest_id not in active_quests:
		return
	
	var quest = active_quests[quest_id]
	if objective_index >= quest["objectives"].size():
		return
	
	quest["objectives"][objective_index]["current"] = progress
	quest_updated.emit(quest_id, progress)
	
	# Check if quest is complete
	if _is_quest_complete(quest_id):
		complete_quest(quest_id)

func increment_quest_objective(quest_id: String, objective_type: String, target: String, amount: int = 1) -> void:
	"""Increment a quest objective (e.g., killed a rat)"""
	if quest_id not in active_quests:
		return
	
	var quest = active_quests[quest_id]
	for i in range(quest["objectives"].size()):
		var obj = quest["objectives"][i]
		if obj["type"] == objective_type and obj["target"] == target:
			obj["current"] = min(obj["current"] + amount, obj["required"])
			quest_updated.emit(quest_id, obj["current"])
			
			if _is_quest_complete(quest_id):
				complete_quest(quest_id)
			break

func on_enemy_killed(enemy_id: String) -> void:
	"""Called when player kills an enemy - updates relevant quests"""
	for quest_id in active_quests:
		increment_quest_objective(quest_id, "kill", enemy_id, 1)

func on_item_collected(item_id: String, amount: int = 1) -> void:
	"""Called when player collects an item - updates relevant quests"""
	for quest_id in active_quests:
		increment_quest_objective(quest_id, "collect", item_id, amount)

func on_npc_talked(npc_id: String) -> void:
	"""Called when player talks to an NPC - updates relevant quests"""
	for quest_id in active_quests:
		increment_quest_objective(quest_id, "talk", npc_id, 1)

func on_area_explored(area_id: String) -> void:
	"""Called when player discovers a new area - updates relevant quests"""
	for quest_id in active_quests:
		increment_quest_objective(quest_id, "explore", area_id, 1)

func _is_quest_complete(quest_id: String) -> bool:
	"""Check if all objectives are complete"""
	if quest_id not in active_quests:
		return false
	
	var quest = active_quests[quest_id]
	for obj in quest["objectives"]:
		if obj["current"] < obj["required"]:
			return false
	
	return true

func complete_quest(quest_id: String) -> void:
	"""Mark quest as completed and give rewards"""
	if quest_id not in active_quests:
		return
	
	var quest = active_quests[quest_id]
	quest["status"] = "completed"
	
	# Give rewards
	if "rewards" in quest:
		var rewards = quest["rewards"]
		if "exp" in rewards:
			GameManager.add_experience(rewards["exp"])
		if "gold" in rewards:
			GameManager.add_gold(rewards["gold"])
		if "items" in rewards:
			for item in rewards["items"]:
				InventoryManager.add_item(item)
	
	# Move to completed
	completed_quests.append(quest_id)
	active_quests.erase(quest_id)
	
	quest_completed.emit(quest_id)
	print("Quest completed: ", quest.get("name", quest_id))

func fail_quest(quest_id: String) -> void:
	"""Mark quest as failed"""
	if quest_id not in active_quests:
		return
	
	var quest = active_quests[quest_id]
	quest["status"] = "failed"
	
	failed_quests.append(quest_id)
	active_quests.erase(quest_id)
	
	quest_failed.emit(quest_id)
	print("Quest failed: ", quest.get("name", quest_id))

func get_active_quests() -> Array:
	"""Get array of active quest data"""
	return active_quests.values()

func get_quest(quest_id: String) -> Dictionary:
	"""Get specific quest data"""
	if quest_id in active_quests:
		return active_quests[quest_id]
	return {}

func is_quest_active(quest_id: String) -> bool:
	"""Check if a quest is active"""
	return quest_id in active_quests

func is_quest_completed(quest_id: String) -> bool:
	"""Check if a quest has been completed"""
	return quest_id in completed_quests
