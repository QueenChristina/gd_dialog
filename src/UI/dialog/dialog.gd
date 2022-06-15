"""
Dialog
A base class for dialogs, supports text animation via BBcode, button choices,
branching dialog, optional avatar icon, and optional name.

Dependencies: Global.db_dialog, GameState.talking

Info:
	Godot Open Dialogue System
	by Tina Qin (QueenChristina)
	https://github.com/QueenChristina/gd_dialog
	License: MIT.
	Please credit me if you use! Thank you! <3
"""
# TODO: export and set (1) Panel container text and (2) Panel container name by loading saved panel styles,
# affectable by theme.
extends Control
class_name Dialog

signal dialog_ended(text_id)

const PAUSE_TIME_MIN = 0.3
const PAUSE_TIME_MAX = 1
export var pause_time := 0.5	# Pause time in seconds when encounter a PAUSE_CHAR
export var text_speed := 0.03 	# Text speed - the seconds to wait until next character.
# Cannot be < 0.01 due to limitations of timer timeout signal. 
	# TODO: automatically skip text if text_speed < 0.001, do not use timer.
	# TODO: move to globals (settings!)
	# TODO: Use setget and global variables on text_speed and pause_time instead so all dialogInstances
	# have the same text_speed setting. HOWEVER, you may also think about setting time based on speaker.


# TODO 2/25/22: there are cyclic dependency issues with using this as child node has same
# name as class -- instead, curr_dialog_node  = $DialogNode (no new nodes made!!!!)
# TODO 2/25/22: Instead use of input action "confirm", use Godot's default input map -- less confusion.
# TODO 2/25/22: Emit signal with starting id text index when end dialogue, not "end".
var curr_dialog_node : DialogNode = null

var talking = false # NOTE: both a GameState.talking and local talking state is set.
# DO NOT CONFUSE THEM. Both are necessary - GameState.talking to inform whether 
# a dialog is currenly shown. local talking to know whether THIS particular
# dialog node is the active node. Error occurs if you replace local with global state
# if there may be multiple dialog UIs in a game.

onready var dialog_UI := self 
onready var text_dialog := $TextBox/Margin/HBox/VBox/Text
onready var text_name := $HBox/NameBox/Margin/Name
onready var box_name := $HBox/NameBox
onready var box_text := $TextBox
onready var icon := $TextBox/Margin/HBox/PanelContainer/Icon
onready var icon_container := $TextBox/Margin/HBox/PanelContainer
onready var curr_voice := $Sound
onready var timer := $Timer
onready var choices := $TextBox/Margin/HBox/VBox/Choices
onready var next_icon := $NextIcon

func _ready():
	_on_set_text_speed(text_speed)
	dialog_UI.hide()
	text_dialog.set_visible_characters(0)
	#start_dialog("text_id")
	
	curr_dialog_node = DialogNode.new()
	self.add_child(curr_dialog_node)

func _input(event):
	if talking and event.is_action_pressed("confirm"):
		continue_dialog()

func start_dialog(first_id):
	GameState.talking = true
	talking = true
	set_curr(first_id)
	timer.start()
	
func end_dialog():
	timer.stop()
	GameState.talking = false
	talking = false
	dialog_UI.hide()
	
## Reduce on number of unneeded nodes and orphans
#func free_dialog_node():
#	if curr_dialog_node != null:
#		curr_dialog_node.queue_free()
#		print("Freed an orphan")
	
# Set curr_dialog_node by text id, the current dialog to display.
func set_curr(id):
	if id == Globals.END_DIALOG_ID:
		end_dialog()
		emit_signal("dialog_ended", id) # FIX: should be id before end.
	else:
		# Set current dialogNode, and free old to prevent orphaned nodes
#		curr_dialog_node = DialogNode.new()
		curr_dialog_node.init(id)
		# Set name box 
		text_name.text = curr_dialog_node.speaker
		box_name.visible = false
		if curr_dialog_node.speaker != "" :
			box_name.visible = true
		# Set text box
		text_dialog.bbcode_text = curr_dialog_node.printable_text
		text_dialog.visible_characters = 0
		# Set icon
		if curr_dialog_node.icon != "none":
			icon.animation = curr_dialog_node.icon
			icon_container.show()
			icon_container.align_icon()
		else:
			icon_container.hide()
		next_icon.hide()
		# Set voice
		curr_voice.init(curr_dialog_node.voice)
		# Set choice buttons.
		choices.hide()
		choices.set_buttons(curr_dialog_node.choices)
		# Resize control nodes and show dialog_UI.
		resize_control_nodes()
		# TODO: Decide whether actions should be executed at start or end of dialog.
		# Currently, executes actions at start of dialog, but after initialization of dialog.
		for act in curr_dialog_node.action:
			Globals.execute(act)
		
# Resizes dialog UI to fit content.
func resize_control_nodes():
		# Godot's quirky hacky workaround: Hide and reshow to resize control node
		# for case when previous content was very long, but current content short.
		dialog_UI.hide()
		dialog_UI.show()

func continue_dialog():
	# Case 1: text was mid printing, so we want to skip text animation and show rest of text
	if text_not_all_visible():
		text_dialog.visible_characters = text_dialog.bbcode_text.length()
		show_choices()
	else:
		# Case 2: text was done printing, so we want to go to next portion of dialog
		if !choices.visible: # Do not set next text if selecting choice.
			var can_move_to_next_id := !curr_dialog_node.set_next_text_index()
			if !can_move_to_next_id:
				# - (A) We can move to next text_index 
				text_dialog.bbcode_text = curr_dialog_node.printable_text
				text_dialog.visible_characters = 0
				next_icon.hide()
				resize_control_nodes()
			else:
				if curr_dialog_node.choices.size() == 0:
					# - (B) We need to move to next_id if no choices
					set_curr(curr_dialog_node.next_id)
				else:
					# - (C) Show choices if there are choces
					choices.show()
					focus_first_choice()
			# Needed for when new text appears after choices.
			timer.start()

# Returns whether there is still text to show in the current box.
func text_not_all_visible() -> bool:
	return text_dialog.visible_characters < text_dialog.text.length() \
			and text_dialog.visible_characters != -1

# Show choices if all text shown and at end of texts [no more text after].
func show_choices():
	if curr_dialog_node.choices.size() != 0 and \
		curr_dialog_node.text_index == curr_dialog_node.texts.size() - 1:
		choices.show()
		focus_first_choice()

# Focus on first button choice if exists.
func focus_first_choice():
	var choices_container = choices.get_child(0)
	if choices_container.get_child_count() > 0:
		choices_container.get_child(0).call_deferred("grab_focus")

# Player chooses a choice, then go to next dialog id accordingly.
func _on_choice_selected(id):
	timer.start()
	set_curr(id)

#======================================Text===================================
func _on_timer_timeout():
	# TODO: updated / fixed this 2/26/22, voice rate was incorrectly forced every itnerval before
	var force_voice = true if text_dialog.visible_characters == 0 else false
	if text_not_all_visible():
		# Pause if hit PAUSE_CHAR just before next visible character.
		if curr_dialog_node.pause_count_at(text_dialog.visible_characters) != 0:
			timer.stop()
			yield(get_tree().create_timer(pause_time), "timeout")
			timer.start()
			force_voice = true # always voice a character after a pause
		curr_voice.voice(force_voice)
		text_dialog.visible_characters += 1
	else:
		show_choices()
		if curr_dialog_node.choices.size() == 0 or \
			curr_dialog_node.text_index < curr_dialog_node.texts.size() - 1:
			# Indicate can move to next text, if no choices to make right now.
			next_icon.show()
		timer.stop()

###############################################################################
# TODO: connect set text speed to in game menu settings w/ hslider
# TODO: move this to a global settings  + connect _on_Text_speed_changed signal
# to change timer.wait_time when change settings
func _on_set_text_speed(speed : float, auto_scale_pause_time = false):
	timer.wait_time = speed
	# Optionally, set pause_time to scale according to text_speed automatically.
	if auto_scale_pause_time:
		pause_time = clamp(speed * 100, PAUSE_TIME_MIN, PAUSE_TIME_MAX)
