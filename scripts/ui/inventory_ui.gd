extends Control
class_name InventoryUI
## Inventory and equipment UI window

signal closed

@onready var inventory_grid: GridContainer = $Panel/VBoxContainer/InventoryGrid
@onready var equipment_slots: Control = $Panel/VBoxContainer/EquipmentSlots
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton

const INVENTORY_SLOT_SCENE = preload("res://scenes/ui/inventory_slot.tscn")

var is_open: bool = false

func _ready() -> void:
	# Hide by default
	visible = false
	
	# Connect signals
	InventoryManager.inventory_changed.connect(_refresh_inventory)
	InventoryManager.equipment_changed.connect(_refresh_equipment)
	
	if close_button:
		close_button.pressed.connect(close)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		toggle()

func toggle() -> void:
	"""Toggle inventory visibility"""
	if is_open:
		close()
	else:
		open()

func open() -> void:
	"""Open inventory"""
	is_open = true
	visible = true
	_refresh_inventory()
	_refresh_equipment()
	
	# Pause game when inventory is open
	GameManager.pause_game()

func close() -> void:
	"""Close inventory"""
	is_open = false
	visible = false
	closed.emit()
	
	# Resume game
	GameManager.resume_game()

func _refresh_inventory() -> void:
	"""Refresh inventory display"""
	if not inventory_grid:
		return
	
	# Clear existing slots
	for child in inventory_grid.get_children():
		child.queue_free()
	
	# Add slots for each inventory item
	for item in InventoryManager.inventory:
		var slot = _create_inventory_slot(item)
		inventory_grid.add_child(slot)
	
	# Add empty slots to fill grid
	var empty_slots = InventoryManager.max_inventory_slots - InventoryManager.inventory.size()
	for i in range(empty_slots):
		var slot = _create_empty_slot()
		inventory_grid.add_child(slot)

func _create_inventory_slot(item_data: Dictionary) -> Control:
	"""Create an inventory slot with item"""
	# TODO: Load actual slot scene
	var slot = Panel.new()
	slot.custom_minimum_size = Vector2(64, 64)
	
	var label = Label.new()
	label.text = item_data["item_id"] + "\n x" + str(item_data["amount"])
	slot.add_child(label)
	
	return slot

func _create_empty_slot() -> Control:
	"""Create an empty inventory slot"""
	var slot = Panel.new()
	slot.custom_minimum_size = Vector2(64, 64)
	return slot

func _refresh_equipment(slot: String = "") -> void:
	"""Refresh equipment display"""
	# TODO: Implement equipment slot display
	pass
