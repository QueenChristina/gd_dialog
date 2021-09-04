extends HBoxContainer

onready var player_name = $PlayerName
onready var button = $Button

signal submitted_player_name

# Called when the node enters the scene tree for the first time.
func _ready():
	player_name.grab_focus()

func _on_submit_name(_name = player_name.text):
	if player_name.text != "":
		Globals.player_name = player_name.text
		button.hide()
		player_name.editable = false
		emit_signal("submitted_player_name")
	else:
		print("Invalid player name.")
