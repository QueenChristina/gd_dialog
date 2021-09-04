extends Area2D

export var connected_scene = "some scene"
export var connected_area_id = "NAME OF AREA"
export var area_id = "NAME OF THIS AREA"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Teleport_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.is_in_group("Player"):
		print("TODO: load new scene and switch scenes. Save old scene depending on scene type.")
		# https://godotengine.org/qa/7940/scene-switching-and-returning
		# https://www.reddit.com/r/godot/comments/gbrt9a/how_to_save_previous_scene_when_switching_scenes/ (option 3)
		# https://www.reddit.com/r/godot/comments/ccfgdw/how_would_you_go_about_loading_a_previous_scene/
		
		# TODO: connect to new scene AND which area in scene to spawn to!
