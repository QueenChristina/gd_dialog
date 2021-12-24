"""
AnimatedSpriteContainer
Unlike TextureRect being a control equivalent for rectangular sprites or textures,
Godot has no control equivalent of animated sprite, which makes positioning animated sprites
in control nodes tricky.
Therefore, this hacky workaround has been made by using the face that rect_min_size
of panel container can create extra space, and is set based on animated icon size.

For simplicity, the current script assumes:
	- All animated icon frames have the approx. same size.
	- There is a "default" animation whose first frame is the same size as all icons.
Does not account for manual scaling of icons - only matches original texture size.
"""
# tool # reload scene to see effect
extends Container
class_name AnimatedSpriteContainer

export var content_margin = Vector2(10, 5)
export(String, "CENTER", "CENTER_BOTTOM") var alignment = "CENTER_BOTTOM"

################################### TODO ######################################
# For more control-like behavior, you may dynamically change the minimum rect size
# depending on rect size of current animated sprite frame. I'll leave this excersize
# up to you if your game requires this capability.

# NOTE:
# When using spritesheets, get_size of texture may not be appropriate since it gets spritesheet, not frame texture.
# You can use the below solution to calculate frame texture size.
# https://godotforums.org/discussion/25732/how-to-get-the-current-frame-texture-from-an-animatedsprite-when-using-a-sprite-sheet

##############################################################################
onready var anim_img = $Icon
var default_img_size = Vector2(50, 50)

# Called when the node enters the scene tree for the first time.
func _ready():
	default_img_size = anim_img.frames.get_frame("default", 0).get_size() 
	set_content_margin()
	align_icon()
	
# Set spacing to be minimum animation frame size and content margin.
func set_content_margin():
	self.rect_min_size = default_img_size + content_margin
	align_icon()
	
# Center animated icon to be anchored to alignment.
func align_icon():
	anim_img.centered = true
	if alignment == "CENTER_BOTTOM":
		# Change animation position to be centered (self.rect_min_size / 2) and
		# anchored to the bottom considering content_margin (Vector2(0, content_margin.y / 2)),
		# accounting for current animation size.
		var anim_img_size = anim_img.frames.get_frame(anim_img.animation, 0).get_size()
		anim_img.position = (self.rect_min_size) / 2 + Vector2(0, content_margin.y / 2) + \
				Vector2(0, (default_img_size.y - anim_img_size.y) / 2)
				#				(default_img_size - anim_img_size) / 2
	else:
		# Center
		anim_img.position = self.rect_min_size / 2
