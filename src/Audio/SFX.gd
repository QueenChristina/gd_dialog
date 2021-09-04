extends AudioStreamPlayer

var item_pickup = preload("res://Audio/SFX/item_pickup.wav")
var swish = preload("res://Audio/SFX/swish.wav")

func _ready():
	Globals.connect("play_sound", self, "_on_play_sound")

func _on_play_sound(sound : String):
	print("Playing sound " + sound)
	self.stream = get(sound)
	self.play()
