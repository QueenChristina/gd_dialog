extends Node

export var talk_id = "welcome"

onready var anim_player = $AnimationPlayer
onready var name_setter = $CanvasLayer/SetName

func _ready():
	GameState.cutscene = true

func speak_from_abyss(id):
	UI.connect("dialog_ended", self, "_on_dialog_ended")
	UI.start_dialog(id, "black")
	anim_player.play("Dark")

func _on_dialog_ended(_id):
	# get out of the abyss.
	anim_player.play("FadeOut")
	UI.disconnect("dialog_ended", self, "_on_dialog_ended")
	name_setter.hide()

func _on_submitted_player_name():
	GameState.cutscene = false
	speak_from_abyss(talk_id)
