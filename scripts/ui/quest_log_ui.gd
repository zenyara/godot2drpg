extends Control
class_name QuestLogUI
## Quest log UI window

signal closed

@onready var quest_list: VBoxContainer = $Panel/VBoxContainer/ScrollContainer/QuestList
@onready var quest_details: RichTextLabel = $Panel/VBoxContainer/QuestDetails
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton

var is_open: bool = false
var selected_quest_id: String = ""

func _ready() -> void:
	# Hide by default
	visible = false
	
	# Connect signals
	QuestManager.quest_started.connect(_refresh_quest_list)
	QuestManager.quest_updated.connect(_refresh_quest_list)
	QuestManager.quest_completed.connect(_refresh_quest_list)
	
	if close_button:
		close_button.pressed.connect(close)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_quest_log"):
		toggle()

func toggle() -> void:
	"""Toggle quest log visibility"""
	if is_open:
		close()
	else:
		open()

func open() -> void:
	"""Open quest log"""
	is_open = true
	visible = true
	_refresh_quest_list()

func close() -> void:
	"""Close quest log"""
	is_open = false
	visible = false
	closed.emit()

func _refresh_quest_list(quest_id: String = "", progress: int = 0) -> void:
	"""Refresh quest list display"""
	if not quest_list:
		return
	
	# Clear existing entries
	for child in quest_list.get_children():
		child.queue_free()
	
	# Add active quests
	var active_quests = QuestManager.get_active_quests()
	for quest in active_quests:
		var quest_button = Button.new()
		quest_button.text = quest.get("name", "Unknown Quest")
		quest_button.pressed.connect(_on_quest_selected.bind(quest["id"]))
		quest_list.add_child(quest_button)
	
	# If a quest was previously selected, update details
	if not selected_quest_id.is_empty():
		_display_quest_details(selected_quest_id)

func _on_quest_selected(quest_id: String) -> void:
	"""Called when a quest is selected from the list"""
	selected_quest_id = quest_id
	_display_quest_details(quest_id)

func _display_quest_details(quest_id: String) -> void:
	"""Display details of the selected quest"""
	if not quest_details:
		return
	
	var quest = QuestManager.get_quest(quest_id)
	if quest.is_empty():
		quest_details.clear()
		return
	
	# Build quest details text
	var details_text = "[b]" + quest.get("name", "Unknown Quest") + "[/b]\n\n"
	details_text += quest.get("description", "No description") + "\n\n"
	details_text += "[b]Objectives:[/b]\n"
	
	for obj in quest.get("objectives", []):
		var current = obj.get("current", 0)
		var required = obj.get("required", 0)
		var completed = current >= required
		var checkbox = "[X]" if completed else "[ ]"
		details_text += checkbox + " " + obj.get("target", "Unknown") + ": " + str(current) + "/" + str(required) + "\n"
	
	details_text += "\n[b]Rewards:[/b]\n"
	var rewards = quest.get("rewards", {})
	if "exp" in rewards:
		details_text += "Experience: " + str(rewards["exp"]) + "\n"
	if "gold" in rewards:
		details_text += "Gold: " + str(rewards["gold"]) + "\n"
	
	quest_details.clear()
	quest_details.append_text(details_text)
