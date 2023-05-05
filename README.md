# What is this?
This is a quick template to jumpstart a Godot 3 project, intended mostly for game jams and small stuff.

# What does it do?
It adds a lot of common functionality that's useful in almost any kind of game and is more or less trivial, but time consuming, to implement, such as pause, volume options, etc.

# How to use?
This is just a normal Godot 3 project. Download it and open it with Godot >=3.5.1.

# Feature list
- **Pause menu**: Drag & Drop `UI/PauseMenu/PauseMenu.tscn` wherever you like and get a simple pause menu to be brought up with Escape or Start.
- **Options menu**: Drag & Drop `UI/OptionsMenu/OptionsMenu.tscn` wherever you like. Has a couple of options:
    - Music & SFX Volume
    - Language
    - Resolution & Fullscreen
    - Font size
    - Make sure you bind the `pressed` signal from `cancel_button` to a callback to hide the menu, or else it won't do anything.
    - It'll automatically override any test resolution in project settings. You can launch the `OptionsMenu.tscn` by itself to change resolution for testing.
- **Audio volume control**: Put the `Misc/VolumeControlASP.gd` on any `AudioStreamPlayer` node to automatically have its volume adjusted by the settings in options. Also allows to change base volume with linear percentages rather than decibels.
- **Saving**: A very simple system to save and load variables to disc for persisting data between sessions. Better used for achievements, unlocks, and the like: if you want to make a full-on game save, look up a better and more comprehensive solution.

# Can I use this for commercial purposes?
Yes.

# How do I do X? / How does Y work?
If something from the template is unclear, make an issue in GitHub and I'll and and update this readme (eventually).