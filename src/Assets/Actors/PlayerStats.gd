extends Node

# Player stats eg. health, inventory, skills, etc
# https://github.com/GDQuest/godot-make-pro-2d-games/tree/master/actors/player

var inventory = {} # item : amount, item must match item in db_items

# Adds single item to inventory.
# Amount must be >= 0
func add_inventory_item(item, amount):
	if inventory.has(item):
		inventory[item] += amount
	else:
		if amount > 0:
			inventory[item] = amount
	print("Current player inventory: " + str(inventory))

# Removes item from inventory of amount.
# Amount must be >= 0.
# Returns whether removal was successful.
func remove_inventory_item(item, amount):
	# Attempt to remove one item.
	if inventory.has(item) and inventory[item] >= amount:
		inventory[item] -= amount
		if inventory[item] == 0:
			# Remove item key:value pair if zero items.
			inventory.erase(item)
		print("Current player inventory: " + str(inventory))
		return true
	# Not enough of item to remove.
	print("Current player inventory: " + str(inventory))
	return false
