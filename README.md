# Godot Dialog System
Open source robust dialogue system in Godot, with an in game example.

## Features
Robust dialog system
* Branching dialog
    * Show dialog depending on previous choices
* Conditional dialog
    * Show dialog and choices depending on in-game variables
* Execute actions with dialog
    * Easily shake screen, add and remove items from player inventory, , and so on, all from the comfort of a single .json file
* Easily customizable
    * Use of control nodes makes it easy to re-size, and use themes or textures of your choice to change the style of dialog
    * Possible to use different styles of dialog depending on the speaker
* Beautiful sound and voice
    * Separate voices database allows you to easily change voice per dialog
        * Typewriter style sound with simple modifications allows for a wide variety of sound with little effort
    * Button sounds are satisfying and responsive
* Animated character icons
* Keyboard accessible
    * All dialog actions are navigatable by keyboard - no mouse needed!
* Scalable
    * Modifying dialog from a single .json file allows for dialog to be scalable to large sized games -- adding dialog takes no more effort than typing the dialog up (no game engine shenanigans needed!)
    * Optional parameters makes it simple to use for small games too

Includes an example of how the dialog system might work with a top-down RPG. However, it is easily used for other styles of games as well with minor to no modification, eg. visual novels, etc.

## Getting Started
You add dialog to your game via .json file.

Three examples of adding dialog to your game:
```
"robust_text_id" : {
	"name": "Qin Tina", 
	"icon": "God_png", 
	"voice": "manly",
	"text": ["This is the most feature-rich dialog with choices you can make.",
               "Don't you think this is so cool?!?"], 
	"choices": [ 
			{"text" : "Agreed.", "next" : "text_id_if_agree", "action": ["show confetti"]},
			{"text" : "Disagreed.", "next" : "text_id_if_disagree", "action": ["go to jail"],
                "show_only_if": "player status insane"}
		],
	"action" : ["screen shake", "play_sound cheering"]
	},

"conditional_text_id" : {
	"text": ["You can move to the next dialog text depending on in-game variables."], 
	"next": [{"id": "text_id", "if": "already talked"},
            {"id": "other_text_id", "if": "has 5 specific_items"},
            "fallthrough_text_id"],
	},

"simple_text_id": {
	"text": ["This is the simplest dialog you can make."]
	},
```

You can also create custom dialog in-game by creating dialog text in the format specified above and adding it to `db_dialog`, a database of all dialogs. This will allow for easier creation of dynamic text that might display in-game variables.

You can add in commonly used variables in dialog using reserved special characters. For instance, if the player name is John Smith:
```
"text_id": {
	"text": ["Hello, &."]
	},
```
will display in game as
```
Hello, John Smith.
```
You can also dynamically control text speed in a single dialog:
```
"text_id": {
	"text": ["I'm s|t|u|t|t|e|r|i|n|g. This ||| is a longer pause."]
	},
```
will add pauses where the reserved special character `|`.

Code is easily modifiable to change reserved character, and to add more special characters with custom behaviors.

## License
The project is licensed under MIT license. Please feel free to use for your games, whether commercial or non-commercial! Just be sure to credit me!

```
Dialog system by Qin Tina
> Twitter
> Youtube
```

Exceptions:
* Music
    * The music is made by [Joshua McLean](https://joshua-mclean.itch.io), licensed under Creative Commons Attribution 4.0 International

## Acknowledgements
* [Dialogic](https://github.com/coppolaemilio/dialogic) (my personal favorite)
* 

## Support Me
If you liked this project, or felt this was useful, please leave me a comment and feedback! It would really make my day.

And, if you ever make a game with this, I'd love a know! Please send me a link of your game so I can support it! <3