extends Camera2D

# Limits of camera determined by environment TileMap (should be rectangular)
export(NodePath) var environment_path

# Screen shake variables.
export(float) var amplitude = 6.0
export(float) var duration = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING = 1.0
export(bool) var shake = false setget set_shake

onready var timer = $Timer
onready var environment = get_node(environment_path)

enum States {IDLE, SHAKING}
var state = States.IDLE

func _ready():
	set_camera_limits(Vector2(1, 1))
	set_process(false)
	Globals.connect("screen_shake", self, "set_shake", [true])

# Set camera limits based on tileMap.
func set_camera_limits(cutoff):
	# Cutoff: the number of tiles to symetrically cutoff (exclude) from the camera bounds
	# (+) - removes tiles from view
	# (-) - camera goes beyond map rectangular limit
	# Normally, would cutoff = Vector2(1,1) to exclude outer tiles used as collision bounding box
	var map_limits = environment.get_used_rect()
	var map_cellsize = environment.cell_size
	self.limit_left = (map_limits.position.x + cutoff.x) * map_cellsize.x
	self.limit_right = (map_limits.end.x - cutoff.x) * map_cellsize.x
	self.limit_top = (map_limits.position.y + cutoff.y) * map_cellsize.y
	self.limit_bottom = (map_limits.end.y - cutoff.y) * map_cellsize.y

# Screen shake based on 
# https://github.com/GDQuest/godot-make-pro-2d-games/blob/master/actors/camera/ShakingCamera.gd
func set_duration(value):
	duration = value
	if not timer:
		return
	timer.wait_time = duration

func set_shake(value = true):
	shake = value
	if shake:
		_change_state(States.SHAKING)
	else:
		_change_state(States.IDLE)

func _change_state(new_state):
	match new_state:
		States.IDLE:
			offset = Vector2()
			set_process(false)
		States.SHAKING:
			set_process(true)
			timer.start()
	state = new_state

func _process(delta):
	var damping = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)

func _on_ShakeTimer_timeout():
	self.shake = false
