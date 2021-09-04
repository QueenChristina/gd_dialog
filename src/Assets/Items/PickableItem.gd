extends TalkableItem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Override funtion to make item disappear after pickup.
func _on_dialog_ended(_text_id):
	UI.disconnect("dialog_ended", self, "_on_dialog_ended")
	self.queue_free()
