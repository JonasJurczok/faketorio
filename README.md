# Faketorio
![Logo](https://github.com/JonasJurczok/faketorio/raw/master/img/faketorio.jpg)

[![Travis](https://img.shields.io/travis/JonasJurczok/faketorio.svg)](https://travis-ci.org/JonasJurczok/faketorio)
[![LuaRocks](https://img.shields.io/luarocks/v/jasonmiles/faketorio.svg)](https://luarocks.org/modules/jasonmiles/faketorio)
[![Coveralls](https://img.shields.io/coveralls/JonasJurczok/faketorio.svg)](https://coveralls.io/github/JonasJurczok/faketorio)
[![license](https://img.shields.io/github/license/jonasjurczok/faketorio.svg)](https://opensource.org/licenses/MIT)

Support library for automated testing of Factorio mods

## Purpose
The problem with modding in Factorio (or any other script language based modding environment) is testing.
Usually this is solved by a huge amount of manual testing. This amount grows with every new feature and every bugfix.. because in theory you have to test EVERYTHING EVERY.SINGLE.TIME (super annoying).

This is where automated testing comes in. I'm new to lua testing, but there are [a couple](http://lua-users.org/wiki/UnitTesting) unit testing frameworks available.

The problem with unit testing is that it only gets you so far. The most interesting aspect (how does it behave in the real game) is hard to mimic.

Enter Faketorio. The goal is to provide a standard system for running your mod against your local Factorio installation, execute tests INSIDE
Factorio and then package your mod for release.

## TODO
A lot of things are still incomplete. Namely
* Actually zipping the mod for upload. Assembling a folder works already, zipping is still missing
* Running the tests

## Installation

If you use [LuaRocks](https://luarocks.org) for your lua modules it is as easy as running `luarocks install faketorio`.

If you do all the dependency management yourself you will have to download the files from this github repo and place them in a convenient location. Then `require` them with the proper path.

## Usage

For a (very) short info on how to interact with faketorio type `faketorio -h`. For the long version keep reading :)

There are two main aspects of faketorio regarding your mod. The first is mod management and packaging and the second is testing.

### Mod management

With Faketorio you can run and build your mod. To do this we need two things: a `.faketorio` config file in your home folder and a certain folder
structure in your mod.

#### Folder structure

Faketorio assumes the following structure for your mod files:
```
- MyModFolder/
    - info.json     // the file with all your mod info
    - src/          // all your mod source files go here (in as many subfolders as you like)
        - control.lua
        - data.lua
        - settings.lua
        - mymod.lua
    - locale/       // all your locale files as described in [aubergine10's guide to localization](https://github.com/aubergine10/Style/wiki/Localisation)
    - spec/         // all your test files go here (as described by [busted](https://olivinelabs.com/busted/#defining-tests)
    - target/       // temporary folder that faketorio uses to assemble files and folders
```

The Factorio specific files (`control.lua`, `data.lua`, `settings.lua`, ...) all go into the source folder without any additional subfolders.

#### .faketorio config file
Faketorio requires a config file in your home folder (`/home/<USER>/` on Linux systems, TODO: test windows systems).
This file has to have three values configured.

```properties
factorio_mod_path = /home/jjurczok/.factorio/mods
factorio_run_path = /home/jjurczok/.local/share/Steam/steamapps/common/Factorio/bin/x64/factorio

faketorio_path = /usr/share/lua/5.2/faketorio
```

TODO: add windows based examples

`factorio_mod_path` describes the folder where all your mods are. On my machine this is in the home folder, on windows it will be somewhere else
`factorio_run_path` is the path to the executable (Factorio.exe on windows)

`faketorio_path` is the path where you installed faketorio itself. If you installed it via `luarocks` you can find this path with `luarocks show faketorio` or `luarocks doc faketorio`

#### Faketorio commands

With the configuration in place and the mod structured we can now start interacting with faketorio. Faketorio should be run from your mod folder.
To do this open a terminal (or command line with start -> execute -> cmd on windows) and navigate to the folder where you do your development (ideally NOT inside the Factorio mods folder ;).

Now you can execute the faketorio commands to interact with your mod and Factorio.

* `faketorio build` \
This command creates a properly named folder in the target folder that is named according to the Factorio mod naming conventions (ModName_Version). The information
for this are extracted from your `info.json`. This mod can then be zipped and uploaded to the mod portal (TODO: Zip is done for you).
* `faketorio run` \
This command does roughly the same as the `build` command. Except that it also copies the folder to your factorio mod folder and then starts Factorio.
It will order Factorio to create a new map, load your mod and then run Factorio with that newly generated map. This gives you a clean game to test your mod.
As Factorio loads mods that are not zipped over mods that are zipped you don't even have to change the version number in your `info.json`.
* `faketorio copy` \
This command is used to reduce the `develop -> copy mod -> start Factorio -> test -> close Factorio -> develop` cycle.
If you already have Factorio running this command will replace the mod in the Factorio mods folder with the version that you are currently developing.
With this you can just click `restart map` in the game and have the newest version of the mod loaded. ATTENTION: changing locales/grafics requires a restart of the game
as these resources are only loaded on game startup.
* `faketorio test` \
This command works like the run command except that it also adds all your `faketorio feature files` to the mod, enabeling you to run your
automated tests inside Factorio. Simply wait for Factorio to finish loading and then type `/faketorio` into the debug console ingame.
ATTENTION: This is not completely implemented yet!!
* `faketorio clean` \
This command simply removes the target folder to give you a clean start (if in doubt about the contents and you want to force a regeneration of the mod)

### Tests

This is not implemented yet. The general idea is to have some sort of interaction layer that lets you control Factorio like a player would do it
(click on things, type text etc).

## Credits

Faketorio is inspired by [Factorio stdlib](https://github.com/Afforess/Factorio-Stdlib) and the work Afforess did there to enhance the testing.
Over time I hope to become as complete as this testing system.
