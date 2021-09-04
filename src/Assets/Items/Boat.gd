extends TalkableItem

# note: set talk_id from the editor!
onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

## Override TalkableItem function to allow custom Boat behavior.
#func _on_dialog_ended(text_id):
#	# A slightly hacky way of allowing item to be interactable again w/o re-entering area
#	# after dialog ends, but without accidentally triggering it on last click,
#	yield(get_tree().create_timer(0.3), "timeout")
#	interactable = true
#	print(text_id) # FIX: should be id before end.
#	# TODO: based on text_choice chosen -> either emit signal w/ choice on dialog_end
#	# or separate signal (eg: press button, emit custom action in dialog text
#	# ideally, separate action + global signal as then don't need to override this!
#	# eg. button - yes: then action: "emit_signal get_on_boat", or start animation player
##	sprite.animation = "Full"
## START ANIMPLAYER

# TODO: disable interactable when playing cutscene
# or node.set_process_input(!pause) disable input
