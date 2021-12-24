"""
DialogChoices recieves an array of choices and creates buttons for each choices
with cooresponding next dialog id accordingly. Visibility is controlled by parent dialog UI.

Dependencies:
	Globals.END_DIALOG_ID
"""

extends HBoxContainer
class_name DialogChoices

signal choice_selected(next_id)

onready var button_container = $VBox
onready var button_sound = self.owner.get_node("ButtonSound")

# TODO: If choices text short, then add columns instead of rows, looks nicer for Yes/No.
# (1) Add HBox + Button if choices total text length is short enough (horizontal style)
# (2) Add VBox + Button if choices text length is long (column style)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Creates and connects each button in the button container, representing choices.
# 	choices - an array of format: 
#	[{	"text" : "choice_text", 
#		"next" : "next_dialog_id", 
#		"action" : "what to do on choice selected"
#		"show_only_if" : "show this choice only if this condition is met"}]
func set_buttons(choices):
	# Delete old choices from previous dialogs.
	for button in button_container.get_children():
		button.queue_free()
	# Populate with current choices.
	for choice in choices:
		if not ("show_only_if" in choice) or \
			("show_only_if" in choice and Globals.is_condition_met(choice["show_only_if"])):
			# Show choice button if there is no conditional.
			# If there is a condition, only show choice if the condition in show_only_if is met.
			var button = Button.new()
			button.text = choice["text"]
			button_container.add_child(button)
			var next_id = choice["next"]
			if next_id == "" :
				next_id = Globals.END_DIALOG_ID
			var action = null
			if "action" in choice:
				action = choice["action"]
			button.connect("pressed", self, "_on_button_pressed", [next_id, action])
			button.connect("focus_entered", button_sound, "_on_choice_hovered")
			button.connect("mouse_entered", button_sound, "_on_choice_hovered")
	# Error checking; expect to have at least one visible choice.
	if choices.size() > 0 and button_container.get_child_count() == 0:
		print("WARNING: No choices set. Check your conditionals.")

func _on_button_pressed(next_id, action):
	# Execute actions associated with choosing button choice.
	# Make sure to execute actions BEFORE moving onto next dialog/emitting signal that choice was selected
	if action:
		for act in action:
			Globals.execute(act)
	emit_signal("choice_selected", next_id)

