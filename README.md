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
    - info.json             // the file with all your mod info
    - src/                  // all your mod source files go here (in as many subfolders as you like)
        - control.lua
        - data.lua
        - settings.lua
        - mymod.lua
    - locale/               // all your locale files as described in [aubergine10's guide to localization](https://github.com/aubergine10/Style/wiki/Localisation)
    - spec/                 // all your test files go here (as described by [busted](https://olivinelabs.com/busted/#defining-tests)
        - mod_spec.lua      // normal [busted](https://github.com/Olivine-Labs/busted) unit tests (or any other tests for that matter)
        - mod_feature.lua   // faketorio tests that are run inside of Factorio
    - target/               // temporary folder that faketorio uses to assemble files and folders
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
This will simply create a properly named and filled folder in the `target` folder. This is the basis for all
other commands and will be executed implicitly for you. You can use it to verify the contents of
your packaged mod before it actually gets packaged.
* `faketorio clean` \
This command simply removes the target folder to give you a clean start (if in doubt about the contents and you want to force a regeneration of the mod)
* `faketorio copy` \
This command is used to reduce the `develop -> copy mod -> start Factorio -> test -> close Factorio -> develop` cycle.
If you already have Factorio running this command will replace the mod in the Factorio mods folder with the version that you are currently developing.
With this you can just click `restart map` in the game and have the newest version of the mod loaded. ATTENTION: changing locales/grafics requires a restart of the game
as these resources are only loaded on game startup.
* `faketorio package` \
This command creates a properly named folder in the target folder that is named according to the Factorio mod naming conventions (ModName_Version). The information
for this are extracted from your `info.json`. This mod can then be zipped and uploaded to the mod portal (TODO: Zip is done for you).
* `faketorio run` \
This command does roughly the same as the `build` command. Except that it also copies the folder to your factorio mod folder and then starts Factorio.
It will order Factorio to create a new map, load your mod and then run Factorio with that newly generated map. This gives you a clean game to test your mod.
As Factorio loads mods that are not zipped over mods that are zipped you don't even have to change the version number in your `info.json`.
* `faketorio test` \
This command works like the run command except that it also adds all your `faketorio feature files` to the mod, enabeling you to run your
automated tests inside Factorio. Simply wait for Factorio to finish loading and then type `/faketorio` into the [debug console](https://wiki.factorio.com/Console) ingame.
ATTENTION: This is not completely implemented yet!!

### Tests

Now that we covered how to interact with Factorio itself it is time to talk about the real reason for this library. The actual testing.

The tests are inspired by [busted](https://github.com/Olivine-Labs/busted) and use roughly the same basic principles.

```lua
-- in mod_feature.lua
feature("My first feature", function()
    
    scenario("The first scenario", function()
        faketorio.click("todo_maximize_button")
        faketorio.print("my first test")
    end)

    scenario("The second scenario", function()
        faketorio.print("Scenario 2")
    end)
end)
```

As described in `Folder Structure` you can create feature files in your `spec` folder. These files have to follow the naming pattern
`<name>_feature.lua`. It is best practice to have one feature per file.

In the scenarios you can basically write normal lua code to interact with your mod. Faketorio provides you with some additional
functions that you can use.

#### Running tests ingame
To run your tests inside of Factorio simply invoke `faketorio test` in a terminal in the mod folder. 
Faketorio will generate a new map, copy your mod and the tests and starts Factorio.

As soon as you are in game you can open the [debug console](https://wiki.factorio.com/Console) and enter
`/faketorio`. Simply run the command and all your tests will be executed.

#### Marking tests as success/failure

By default any scenario function that completes is counted as successful.
If you want to mark your test as a failure (because some assertion did not work) you can just raise an [error](https://www.lua.org/pil/8.3.html)

```lua
-- in mod_feature.lua
feature("My first feature", function()
    
    scenario("The first scenario", function()
        faketorio.print("This test is successful.")
    end)

    scenario("The second scenario", function()
        faketorio.print("This test fails.")
        error("test failure")
    end)
end)
```

At the end of every test run you will receive a report to the console (and the logfile) indicating what worked and what did not.
As usual a testrun is only successful if ALL tests pass!

TODO: provide screenshots of success and failure cases
```
TESTRUN FINISHED: SUCCESS
Run contained 1 features.
```

#### Interacting with Factorio

Of course just interacting with the data/tables of your mod is not enough. You also have to be able to mimic player behaviour.
This is what the following functions are for.

##### faketorio.click(name)

To interact with your mod you need to be able to click on things ;) This is what the `click` function is for.
The `name` parameter is the `name` of your [gui element](http://lua-api.factorio.com/latest/LuaGuiElement.html). 

Faketorio will search through the four guis (left, top, center, goal) of the **first** player in the players list.
If an element with the provided name is found it will [raise an event](http://lua-api.factorio.com/latest/LuaBootstrap.html#LuaBootstrap.raise_event)
for this element.

Currently only left mouse button clicks without modifiers (shift, alt, control) are supported.

##### faketorio.enter_text(name, text)
This function enters text into a text field. Simply provide a `name` to look for and faketorio
will replace the `.text` attribute with the provided `text`.

##### faketorio.find_element_by_id(id, player)

Returns a [gui element](http://lua-api.factorio.com/latest/LuaGuiElement.html) with the given `id` for the given `player`.
Both parameters are mandatory.


##### faketorio.print(message, parameters)

The print function is intended for debug output and if you want to report something to the user while the tests are running.
This function will print the message to every player in Factorio. Additionally it will be written to the `faketorio.log` file
in your Factorio `script-output` folder in your [application directory](https://wiki.factorio.com/Application_directory).

The `parameters` parameter is a optional array of arbitrary data. If it is provided the `message` will be interpreted as a [format string](http://lua-users.org/wiki/StringLibraryTutorial)
and the `parameters` will be used as attributes to `string.format()`.

## Credits

Faketorio is inspired by [Factorio stdlib](https://github.com/Afforess/Factorio-Stdlib) and the work Afforess did there to enhance the testing.
Over time I hope to become as complete as this testing system.
