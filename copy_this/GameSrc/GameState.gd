extends Node

# Handles pausing, unpausing, and letting other nodes know the current
# state of the dialogue system.

# TODO: You have to implement how the game reacts to the pause/unpause signal
# yourself. Pause/unpause is emitted when dialogue starts/ends.
# To do so, connect the responding node to the signal, and implement
# function that happens when signal is recieved.

signal pause
signal unpause

var talking = false setget set_state_talking, get_state_talking
var cutscene = false setget set_state_cutscene, get_state_cutscene
	
func set_state_talking(is_talking):
	talking = is_talking
	if is_talking:
		emit_signal("pause")
	elif not is_paused():
		# This check is necessary in case, for example, talking and cutscene both occur asynch.
		emit_signal("unpause")
	
func get_state_talking():
	return talking
	
func set_state_cutscene(is_cutscene_playing):
	cutscene = is_cutscene_playing
	if is_cutscene_playing:
		emit_signal("pause")
	elif not is_paused():
		emit_signal("unpause")
	
func get_state_cutscene():
	return cutscene
	
# Returns whether game is paused. Manually setting how nodes react to this setting
# allows greater control than get_tree().paused = true
func is_paused():
	return talking or cutscene
