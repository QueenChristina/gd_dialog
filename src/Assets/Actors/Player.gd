extends KinematicBody2D

const MAX_SPEED = 150
var velocity = Vector2.ZERO

# Based on HeartBeasts' Action RPG
# https://www.youtube.com/watch?v=mAbG8Oi-SvQ&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a

# Different states
enum{MOVE, 
	ATTACK,
	INTERACT
}

var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var sprite = $Sprite
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		
func move_state(delta):
	var input_vector = Vector2.ZERO
	# Get action strength is 0 to 1 for joypad; 1 for keyboard if pressed
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Run only if game not paused.
	if input_vector != Vector2.ZERO and !GameState.is_paused():
		# Set idle here so it will 'remember' the last direction
		# based on coordinate grid triangle in tree.
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		sprite.flip_h = input_vector.x < 0
		animationState.travel("Run")
		# Multiply velocity by delta incase of computer lag
		velocity = MAX_SPEED*input_vector * delta
	else:
		# Not moving
		animationState.travel("Idle")
		velocity = Vector2.ZERO
	move_and_collide(velocity)
	
func attack_state(_delta):
	# velocity = Vector2.ZERO #to stop sliding
	# with separate function, end attack by change state
	pass
