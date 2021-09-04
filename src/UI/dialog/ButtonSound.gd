extends AudioStreamPlayer

var chosen = preload("res://Audio/SFX/blip.wav")
var hovering = preload("res://Audio/SFX/boop.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_choice_selected(_next_id):
	play_sound(chosen)

func _on_choice_hovered():
	play_sound(hovering)

func play_sound(sound):
	self.stream = sound
	self.play()
