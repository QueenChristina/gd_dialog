extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("play_animation", self, "_on_play_animation")

func _on_play_animation(animation):
	print("Playing cutscene " + animation)
	self.play(animation)
	GameState.cutscene = true

func _on_animation_finished(_anim_name):
	GameState.cutscene = false
