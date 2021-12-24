extends CanvasLayer

signal dialog_ended(text_id)
onready var dialog = $Dialog

func start_dialog(index, dialog_style = ""):
	# TODO: you can specify your own dialog style and change
	# the dialog that does start_dialog - see the example
	dialog.start_dialog(index)

func _on_dialog_ended(text_id):
	emit_signal("dialog_ended", text_id)
