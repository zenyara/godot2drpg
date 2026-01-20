extends Node
## Inventory and equipment management system
## Autoloaded as InventoryManager

signal inventory_changed
signal equipment_changed(slot: String)
signal item_added(item_id: String, amount: int)
signal item_removed(item_id: String, amount: int)

# Inventory data
var inventory: Array = []  # [{item_id, amount, data}, ...]
var max_inventory_slots: int = 20  # Can be expanded with perks

# Equipment slots
var equipped_items: Dictionary = {
	"head": null,
	"chest": null,
	"legs": null,
	"feet": null,
	"hands": null,
	"weapon_main": null,
	"weapon_off": null,
	"accessory_1": null,
	"accessory_2": null,
}

# Pet inventory
var pet_equipped_items: Dictionary = {
	"pet_armor": null,
	"pet_accessory": null,
}

# Banking
var bank_storage: Array = []
var max_bank_slots: int = 50

func _ready() -> void:
	print("InventoryManager initialized")

func add_item(item_id: String, amount: int = 1, item_data: Dictionary = {}) -> bool:
	"""Add item to inventory, returns true if successful"""
	# Check if item is stackable and already exists
	for item in inventory:
		if item["item_id"] == item_id:
			item["amount"] += amount
			item_added.emit(item_id, amount)
			inventory_changed.emit()
			return true
	
	# Add as new item
	if inventory.size() < max_inventory_slots:
		inventory.append({
			"item_id": item_id,
			"amount": amount,
			"data": item_data
		})
		item_added.emit(item_id, amount)
		inventory_changed.emit()
		return true
	
	# Inventory full
	print("Inventory full! Cannot add item: ", item_id)
	return false

func remove_item(item_id: String, amount: int = 1) -> bool:
	"""Remove item from inventory, returns true if successful"""
	for i in range(inventory.size()):
		var item = inventory[i]
		if item["item_id"] == item_id:
			if item["amount"] >= amount:
				item["amount"] -= amount
				if item["amount"] <= 0:
					inventory.remove_at(i)
				item_removed.emit(item_id, amount)
				inventory_changed.emit()
				return true
			else:
				print("Not enough items to remove: ", item_id)
				return false
	
	print("Item not found in inventory: ", item_id)
	return false

func has_item(item_id: String, amount: int = 1) -> bool:
	"""Check if player has item in inventory"""
	for item in inventory:
		if item["item_id"] == item_id and item["amount"] >= amount:
			return true
	return false

func get_item_count(item_id: String) -> int:
	"""Get count of specific item in inventory"""
	for item in inventory:
		if item["item_id"] == item_id:
			return item["amount"]
	return 0

func equip_item(item_id: String, slot: String) -> bool:
	"""Equip an item from inventory"""
	if not has_item(item_id):
		return false
	
	# Unequip current item in slot
	if equipped_items[slot] != null:
		unequip_item(slot)
	
	# Equip new item
	equipped_items[slot] = item_id
	remove_item(item_id, 1)
	equipment_changed.emit(slot)
	return true

func unequip_item(slot: String) -> bool:
	"""Unequip item from slot and return to inventory"""
	if equipped_items[slot] == null:
		return false
	
	var item_id = equipped_items[slot]
	if add_item(item_id, 1):
		equipped_items[slot] = null
		equipment_changed.emit(slot)
		return true
	
	return false

func equip_pet_item(item_id: String, slot: String) -> bool:
	"""Equip an item to pet"""
	if not has_item(item_id):
		return false
	
	if pet_equipped_items[slot] != null:
		unequip_pet_item(slot)
	
	pet_equipped_items[slot] = item_id
	remove_item(item_id, 1)
	return true

func unequip_pet_item(slot: String) -> bool:
	"""Unequip item from pet"""
	if pet_equipped_items[slot] == null:
		return false
	
	var item_id = pet_equipped_items[slot]
	if add_item(item_id, 1):
		pet_equipped_items[slot] = null
		return true
	
	return false

func transfer_to_bank(item_id: String, amount: int = 1) -> bool:
	"""Transfer item from inventory to bank"""
	if not has_item(item_id, amount):
		return false
	
	if bank_storage.size() >= max_bank_slots:
		print("Bank is full!")
		return false
	
	# Check if item exists in bank
	for item in bank_storage:
		if item["item_id"] == item_id:
			item["amount"] += amount
			remove_item(item_id, amount)
			return true
	
	# Add new to bank
	bank_storage.append({
		"item_id": item_id,
		"amount": amount,
		"data": {}
	})
	remove_item(item_id, amount)
	return true

func transfer_from_bank(item_id: String, amount: int = 1) -> bool:
	"""Transfer item from bank to inventory"""
	for i in range(bank_storage.size()):
		var item = bank_storage[i]
		if item["item_id"] == item_id and item["amount"] >= amount:
			if add_item(item_id, amount):
				item["amount"] -= amount
				if item["amount"] <= 0:
					bank_storage.remove_at(i)
				return true
			return false
	
	return false

func get_inventory_weight() -> float:
	"""Calculate total inventory weight (if needed for mechanics)"""
	var total_weight = 0.0
	# TODO: Implement item weight system
	return total_weight

func expand_inventory(additional_slots: int) -> void:
	"""Expand inventory size (purchased from perk shop)"""
	max_inventory_slots += additional_slots
	print("Inventory expanded to: ", max_inventory_slots, " slots")

func get_equipped_stats() -> Dictionary:
	"""Calculate total stats from all equipped items"""
	var total_stats = {
		"attack": 0,
		"defense": 0,
		"speed": 0,
		"crit_chance": 0,
		"crit_damage": 0,
		# Add more stats as needed
	}
	
	# TODO: Implement stat calculation from equipped items
	
	return total_stats
