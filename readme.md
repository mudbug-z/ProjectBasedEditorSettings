# About
This is a plugin tool for Godot that updates editor settings based on a config file in the current project directory.
I made this plugin to facilitate multiplayer development, so that I can debug more than one Godot instance at a time
without needed to manually change to ports every time.

## License
MIT

## How to use this plugin
- Create a config file named *editor_settings.cfg*
- Add a section to the config file named *[override]*
- Add settings that you want for this project after override
- Enable the plugin in Godot

Here is a sample configuration file that I use to set a specific debug port
```
[override]
network/debug/remote_port=8019

```
## Caution
This tools changes global editor settings when it is activated, but also creates a backup configuration file for the old settings.
Original settings are restored in 2 cases:
- When starting up (loading a project), original values are restored before applying overrides
- When exiting Godot or closing the project

Be aware that overrides could end up staying in the global configuration and so be used in other projects that do not have the plugin installed.
