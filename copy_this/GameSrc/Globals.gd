"""
Simple Global variables.
TODO: move data to GAME.data or somewhere more organized w/ execute and condition checking, since dialog specific
"""
extends Node

signal screen_shake

export var dialog_file = "res://Data/Dialogue.json"
export var voices_file = "res://Data/Voices.json"

# database of all dialogues and voices, as JSON
var db_dialog 
var db_voices
var END_DIALOG_ID = "end" # The dialog next_id that will end the dialog, reserved keyword.
var data = {} # TODO: keep data here, but move actionHandler # In game global data, used for conditionals in dialog

var player_name = "Bobby" # TODO: move to Player stats

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: Store in global variables, so load only once per file (not each instance of Dialog)
	db_dialog = LoadFile(dialog_file) #Globals.db_dialog
	db_voices = LoadFile(voices_file)
	
# TODO: validate database. Debug script that validates db_dialog and db_voices when loaded. Then, remove 
# in-script warnings.

# Executes an action, currently supports:
# - "emit_signal args". Emits a signal (TODO)
# - "play_anim animationName". Emits a signal to play animation by name of animationName.
# - "set variable value". Sets pseudo-variable (string key) in dictionairy with string value. Adds key if doesn't exist.
# - "add quest_name quest_values":. Adds a new quest with quest_values. TODO
# - "end quest_name quest_status": End quest with status (eg. fulfilled, failed) TODO
# TODO: add_Quest in its own key value, NOT in execute, so not all string eg. "add_quest: {"name": "kill", "amount": 5, "mon": "giant rat"} to allow for values
# TODO: move to another, more aptly named singleton.
func execute(act):
	var act_parsed : Array = act.split(" ")
	var command = act_parsed[0].to_lower()
	# First word is always the command keyword, match to pre-scripted options
	if command == "screen":
		# Screen shake
		if act_parsed[1] == "shake":
			emit_signal("screen_shake")
	elif command == "emit_signal":
		# NOTE: signals MUST be defined at the top of this file and match
		# the name of act_parsed[1] exactly to be sent successfuly.
		# Example: act "emit_signal screen_shake"
		# works the same as act "screen shake"
		if act_parsed.size() == 2:
			emit_signal(act_parsed[1])
		elif act_parsed.size() == 3:
			# Emit with String arg
			emit_signal(act_parsed[1], act_parsed[2])
		else:
			# Emit with array args
			emit_signal(act_parsed[1], act_parsed.slice(2, act_parsed.size() - 1))
		print("Emitted signal " + act_parsed[1])
	elif command == "set":
		# Requires three words: command key value. 
		if act_parsed.size() != 3:
			print("WARNING: action " + act + " not set appropriately. Expected three words." + \
						" Recieved " + str(act_parsed.size()))
		# Set custom game data in a dictionary
		var key = act_parsed[1]
		var value = act_parsed[2]
		if not data.has(key):
			print("Created new game data variable " + key + " with value " + value)
		else:
			print("Overwritten game data variable " + key + " to " + value)
		data[key] = value
	# TODO: implement your own custom actions here where act_parsed is the
	# space delineated series of strings determining what action occurs
	# NOTE: Look at src/ for an example with more custom-defined actions.
	else:
		# Action didn't match any presets. A spelling mistake?
		print("Did not understand given action " + act)
	
# Whether a condition (string) is met.	
# condition must be in format of: source_of_variable variable_name conditional_operator value optional_amount
func is_condition_met(condition : String):
	var cond_parsed = condition.split(" ")
	# Error checking
	var num_args = cond_parsed.size()
	if num_args < 4:
		print("WARNING: condition of " + condition + " not set appropriately. Too few args.")
	
	# Check if condition met
	var var_source = cond_parsed[0].to_lower()	# to_lower to check conditionals
	var variable = cond_parsed[1]				# Not to_lower to preserve original intention
	var operator = cond_parsed[2].to_lower()
	var value = cond_parsed[3]
	if var_source == "data":
		# Use variable keys in Globals.data dictionary
		if not data.has(variable):
			print("WARNING: data key of " + variable + "not set. " + \
				"Attempting to compare with defaulted assumed value of false.")
			return compare("false", operator, value)
		else:
			return compare(data[variable], operator, value)
	# TODO: implement your own ways of interpreting/evaluating conditions here where cond_parsed
	# is the space-delineated strings that describe a condition
	# The condition should ultimately evaluate to true or false
	else:
		print("WARNING: Unknown condition of source "+ var_source + ". Defaulting to false.")
	print("WARNING: Unknown condition "+ condition + ". Defaulting to false.")
	return false

# Compares two values with string comparision operator. If operator is not "equal", then 
# values must be castable to integer. Assume types and operators are appropriate.
# TODO: support for floats, beware of floating-point precision
func compare(thing1, operator : String, thing2):
#	print("Comparing if " + thing1 + " is " + operator + thing2)
	if operator == "equal" or operator == "equals" or operator == "is" or operator == "==":
		# May be string or integer values.
		return thing1 == thing2
	elif operator == "not_equal" or operator == "not" or operator == "!=":
		return thing1 != thing2
	elif operator == "less" or operator == "<":
		# Must be castable to integer.
		return int(thing1) < int(thing2)
	elif operator == "greater" or operator == ">":
		return int(thing1) > int(thing2)
	print("WARNING: Couldn't find condition operator " + operator)
	return false

# Loads a file as JSON, returns JSON
func LoadFile(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, file.READ)
		var file_content = parse_json(file.get_as_text())
		if file_content == null:
			print("Could not parse " + file_name + " as JSON." + \
			"Please check syntax is correct, and that file is not empty.")
		return file_content
	else:
		print("File Open Error: could not open file " + file_name)
	file.close()
