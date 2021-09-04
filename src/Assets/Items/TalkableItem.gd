"""
Simple script to allow talkable objects when interacting in Interact area, 
with talk_id.
"""
extends StaticBody2D
class_name TalkableItem

export var talk_id = "0"
var interactable = false
var is_in_interact_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(_event):
	if interactable && Input.is_action_just_released("confirm"):
		UI.connect("dialog_ended", self, "_on_dialog_ended")
		UI.start_dialog(talk_id)
		# to prevent you ending dialogue and immediately reentering...
		interactable = false
		# Set interactable again after end dialog!

func _on_Interact_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.is_in_group("Player"):
		interactable = true
		is_in_interact_area = true

func _on_Interact_body_shape_exited(_body_id, body, _body_shape, _area_shape):
	if body.is_in_group("Player"):
		interactable = false
		is_in_interact_area = false

func _on_dialog_ended(_text_id):
	UI.disconnect("dialog_ended", self, "_on_dialog_ended")
	# A slightly hacky way of allowing item to be interactable again w/o re-entering area
	# after dialog ends, but without accidentally triggering it on last click, 
	# setting to be interactable again only if player is still in area.
	yield(get_tree().create_timer(0.5), "timeout")
	if is_in_interact_area:
		interactable = true
