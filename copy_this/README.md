# Godot Dialog System
Open source feature-rich dialogue system in Godot, with an in game example. This is the code setup documentation.

# Starting dialog
`UI.start_dialog("dialogue_id")` Use the id of the dialogue, such as "test", located in `data\Dialogue.json`.

# Getting Started with Dialog
Please refer to [the project README.md](https://github.com/QueenChristina/gd_dialog) for information on how to use the system itself, features, and more.

To use the system in your project, follow these steps:
* Copy everything in the `copy_this` folder into your project. Make sure the file paths are preserved (ie., `assets`, `audio`, `data`, `UI`, `gameSrc` directories
	are in the **root project directory, eg. res://Assets**).
	* If you get an error about "Fix missing dependencies", then you did not correctly copy everything over -- make sure to preserve relative file paths!
	* Otherwise, you will need to manually fix missing dependencies by telling Godot where each file is located.
* Autoload these as singletons (under Project Settings > Autoload):
	* `res://UI/UI.tscn` as `UI`
	* `res://gameSrc/Globals.gd` as `Globals`
	* `res://gameSrc/GameState.gd` as `GameState`
* Make sure to instance `res://UI/UI.tscn` in whatever scene is running.

**Now, you can call `UI.start_dialog(dialog_id)` from anywhere in the code to start dialog.**

# Customizing / Adding on to the System
Add your own custom voices and dialogues in:
* `res://data/Dialogue.json`, `res://data/Voices.json`
See `res://gameSrc/Globals.gd` for `db_dialog` and `db_voices`, where the voice and dialogue data is loaded.

Navigate to these files:
* Use custom themes and panel styles to change dialog visual style under `res://UI/UI.tscn` and `res://UI/dialog/dialog.tscn`
* `res://gameSrc/Globals.gd`, modify `execute(act)` to define custom actions
* `res://gameSrc/Globals.gd`, modify `is_condition_met(condition):` to define custom conditions
* `res://UI/dialog/dialog_node.gd`, modify `convert_printable(text)` and use `printable.replace` to define custom variables to show in dialog text
* `res://gameSrc/GameState.gd`, you can custom define when the game is in a paused state, and how to react to pausing (such as during when dialog plays)
Use `GameState.is_paused()` to detect whether the game is currently in a paused state (such as if dialog is currently playing) and custom define how your game should react to a paused state.
Connect to GameState's pause and unpause signals to react to game state changes.

# Navigation
Add "Left mouse button click" to ui_accept under input map to proceed dialogue with mouse click.

## Support Me ❤️
If you liked this project, or felt this was useful, please leave me a comment and feedback! It would really make my day.

And, if you ever make a game with this, I'd love a know! Please send me a link of your game so I can support it! <3
