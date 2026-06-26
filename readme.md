# Bloodthief Dev Console

WIP dev console. Report any issues you have.

## How to use

Press the backtick key on your keyboard (<b>`</b>) and type one of the commands in the below cheatsheet. If you want to replay previous command press the up arrow key.


## Docs(cheatsheet)

| Command | Description | Args | Example | Alternates |
|--|--|--|--|--|
| infblood | Gives you infinite blood buff | N/A | `infblood` | `tgm`
|reshade | Applies/removes different shading layers to the scene | SHADE_TYPE: "disabled/normal", "unshaded", "overdraw", "shadowatlas", "normalbuffer", "ocbuffer", "wireframe", "lighting"| `reshade unshaded` | N/A | 
| tcl | Noclip - rather buggy | N/A | `tcl` | N/A | 
| timescale | Changes engine timescale to a percentage | TIMESCALE: float value greater than 0.0. 1.0 = fullspeed| `timescale 0.1` | `ts` | 
| toggle_model | Toggles player model (hand and sword) | N/A | `toggle_model` | N/A |
| toggle_hud | Toggles HUD/UI | N/A | `toggle_hud` | N/A |
| move | Displaces player by x y z | X Y Z | `move 100 0 0` | `mv` |
|setcpoint | Changes player checkpoint then respawns player at it | Checkpoint # | `setcpoint 2` | `c` |
|save| Janky savestate | N/A | `save` | N/A |
|load| Janky loadstate | N/A | `load` | N/A |
|help| DO NOT USE | N/A | `help` | N/A |
