"""
environmentObj
Simple object with different visual types (versions), but same functionality.
Used for environment objects.

curr_type : current type of object, the visual version you want shown
"""
tool # Allows changes to type to be visible from editor
extends StaticBody2D
class_name environmentObj

# Allow types from 1 to MAX_TYPE up to 10
export(int, 1, 10) var curr_type = 1 setget set_curr_type, get_curr_type

# Maximum type of object, numbered from 1 to MAX_TYPE, and of name "Type#"
# Default is 3, but will get updated to match number of nodes w/ name starting with "Type"
var MAX_TYPE = 5
# Naming convention of types is TYPE + number
var TYPE = "Type"

# Called when the node enters the scene tree for the first time.
func _ready():
	count_max_type()

# Change type of bush by changing sprite visibility, based on curr_type
func set_curr_type(type):
	MAX_TYPE = count_max_type()
	if type <= MAX_TYPE:
		# Double check type is valid number
		curr_type = type
		for i in range(1, MAX_TYPE + 1):
			if i != curr_type:
				self.get_node(TYPE + str(i)).visible = false
			else:
				self.get_node(TYPE + str(i)).visible = true
	else:
		print("Whoops! Type " + str(type) + " is over MAX_TYPE of " + \
			str(MAX_TYPE) + ".")
	
func get_curr_type():
	return curr_type

# Counts number of nodes starting with name of "Type". This should match
# all possible types, MAX_TYPES. No other node should be named starting wtih "Type"
func count_max_type():
	var count = 0
	for child in self.get_children():
		if child.get_name().begins_with(TYPE):
			count += 1
	return count

# TODO, on body player enter, play bush sound + leaves sprinkle
# PLEASE EXTEND CLASS!!!! THis class is used for tree too!!!
