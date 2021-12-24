"""
DialogSound
A basic "typewriter" voice-sound synthesis for the text dialog.

For more advanced voice synthesis and options, I recommend you check out: 
https://www.reddit.com/r/GameAudio/comments/2xogzh/procedural_generation_of_speechlike_audio/
https://www.reddit.com/r/gamedev/comments/5hjo8n/dialogue_sound_effects_replacement_for_voice/

For instance, you may keep a dictionairy or json of each possible syllable
and make a sound each syllable, or voice each letter and make a sound based on that.

Dependencies: Global.db_voices
"""
extends AudioStreamPlayer2D
class_name DialogSound

# TODO: define yourself the voice variable name and preload audio here,
# matching the sound value in Voices.json, or just specify
# the path to load audio in Voices.json
var default = preload("res://Audio/boop.wav")

var voice_id := ""
var sound = default
var rate := 15			# Letters + 1 to display before emitting a sound; the rate of speech.
var pitch := 1.2			# Pitch effect applied to base voice sound stream.
var pitch_range := 0.25	# Range of pitch of voice.
var letters_played := 0	# Tracks letters played so far.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(id):
	voice_id = id
	var voice_info = Globals.db_voices[id]
	rate = voice_info["rate"]
	pitch = voice_info["pitch"]
	pitch_range = voice_info["pitch_range"]
	letters_played = 0
	if "sound" in voice_info:
		# (1) You defined sound as audio path
		var file = File.new()
		var does_file_exist = file.file_exists(voice_info["sound"])
		if does_file_exist:
			sound = load(voice_info["sound"])
		else:
		# (2) You defined the sound as preloaded sound file above
			print("WARNING: specified voice sound file does not exist, or you should" + \
					"define as preloaded file with matching name in dialog_voice.gd")
			sound = get(voice_info["sound"])	# Convert string to its sound
	else:
		sound = default
	self.stream = sound

func voice(force_sound = false):
	# Only play sound on every nth letter, there n = rate.
	letters_played = (letters_played + 1) % (rate + 1)
	if letters_played == rate or force_sound:
		# Set voice sound
		var amount = randf() # 0 to 1
		if floor(randf()*2) == 1: # 50% chance neg or pos
			amount *= -1
		self.pitch_scale = pitch + pitch_range * amount
		
		self.play()
