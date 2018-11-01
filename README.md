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
Faketorio requires a config file to run. You can specify the location with the `-c` option. If no config path
is provided faketorio will search for a file named `.faketorio` in the current folder.
This file has to have three values configured.

```properties
factorio_mod_path = /home/jjurczok/.factorio/mods
factorio_run_path = /home/jjurczok/.local/share/Steam/steamapps/common/Factorio/bin/x64/factorio

# windows based example
factorio_run_path = D:\Spiele\Factorio\bin\x64\factorio.exe

faketorio_path = /usr/share/lua/5.2/faketorio
```
`factorio_mod_path` describes the folder where all your mods are. On my machine this is in the home folder, on windows it will be somewhere else
`factorio_run_path` is the path to the executable (Factorio.exe on windows)

`faketorio_path` is the path where you installed faketorio itself. If you installed it via `luarocks` you can find this path with `luarocks show faketorio` or `luarocks doc faketorio`

#### Faketorio commands

With the configuration in place and the mod structured we can now start interacting with faketorio. Faketorio should be run from your mod folder.
To do this open a terminal (or command line with start -> execute -> cmd on windows) and navigate to the folder where you do your development (ideally NOT inside the Factorio mods folder ;).

Now you can execute the faketorio commands to interact with your mod and Factorio.
<table>
  <tbody>
    <tr>
      <th>Command name</th>
      <th>Description</th>
    </tr>
    <tr>
      <td>faketorio build</td>
      <td>
        Creates a subfolder in target/&lt;your mod name_version&gt;.<br>
        The mod name and version are read from the info.json.<br>
        Copies all mod src files, locales and other resources to this folder.<br><br>
        Intended if you want to take a look at your mod but not produce an uploadable zip file.
      </td>
    </tr>
    <tr>
      <td>faketorio clean</td>
      <td>
        Deletes the target folder.
      </td>
    </tr>
    <tr>
      <td>faketorio copy</td>
      <td>
        Copies the mod to the factorio mod folder defined in the .faketorio config.<br>
        In Factorio you can click restart to see the current version of your mod.<br>
        Restarting Factorio is only necessary if you changed locales or graphics.
      </td>
    </tr>
    <tr>
      <td>faketorio package</td>
      <td>
        Creates a zip file that is ready for uploading to the <a href="https://mods.factior.com">factorio mod portal</a>.
      </td>
    </tr> 
    <tr>
      <td>faketorio run</td>
      <td>
        Runs the build and copy command.<br>
        Generates a new Factorio map.<br>
        Factorio is started and this newly generated map is loaded.
      </td>
    </tr> 
    <tr>
      <td>faketorio test</td>
      <td>
        This command runs Factorio on a new map.<br>
        Your mod will also contain all your feature files and the faketorio test engine.<br>
        Ingame type /faketorio in the <a href="https://wiki.factorio.com/Console">debug console</a> to run all your tests.
      </td>
    </tr>      
  </tbody>
</table>

### Tests

Now that we covered how to interact with Factorio itself it is time to talk about the real reason for this library. The actual testing.

The tests are inspired by [busted](https://github.com/Olivine-Labs/busted) and use roughly the same basic principles.

```lua
-- in mod_feature.lua
feature("My first feature", function()
    
    before_scenario(function()
        -- will be called before every scenario in this feature
        -- this is intended for setting up preconditions for this specific feature
    end)

    after_scenario(function()
        -- will be called after every scenario in this feature
        -- this is intended to bring the mod back into a state as it would be expected from the next test
    end)
    
    scenario("The first scenario", function()
        faketorio.click("todo_maximize_button")
        faketorio.log.info("my first test")
    end)

    scenario("The second scenario", function()
        faketorio.log.info("Scenario 2")
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

You will see a dialog popping up in the middle of the screen. The top bar indicates progress on feature level,
the lower bar indicates progress on scenario level for the currently running feature.

If there are test errors they will be documented in the textbox below the progress bar after the testrun finishes.

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

Faketorio provides the following functions

<table>
  <tbody>
    <tr>
      <th>Function name</th>
      <th>Parameters</th>
      <th>Return value/Action</th>
    </tr>
    <tr>
      <td align="top">faketorio.click</td>
      <td align="top">name - the name of the <a href="http://lua-api.factorio.com/latest/LuaGuiElement.html">gui element</a> to click on</td>
      </td>
      <td rowspan="2">If the element exists a defines.events.on_gui_click event for the provided element will be <a href="http://lua-api.factorio.com/latest/LuaBootstrap.html#LuaBootstrap.raise_event">raised</a>.<br>
          If the element does not exist an exception is thrown. <br><br>
          Currently only left clicks without modifiers (ctrl, alt, shift) are supported.
      </td>
    </tr>
    <tr>
      <td/>
      <td>player - (optional) the player who owns the element. <br>
          If not provided the first player in game will be used
      </td>
    </tr>
    <tr>
      <td>faketorio.enter_text</td>
      <td>name - the name of the element to enter text in</td>
      <td rowspan="3">Sets the text attribute of the named element to the text.<br>
          This does NOT fire all the keystroke events you would expect from actually entering the text!
      </td>
    </tr>
    <tr>
      <td></td>
      <td>text - the text to enter</td>
    </tr>
    <tr>
      <td></td>
      <td>player - (optional) the player who owns the element. <br>
                    If not provided the first player in game will be used</td>
    </tr>
    <tr>
      <td>faketorio.find_element_by_id</td>
      <td>name - the name of the element</td>
      <td rowspan="2">Returns the element with the given name.<br>
        Returns nil if the element does not exist.
      </td>
    </tr>
    <tr>
      <td></td>
      <td>player - The player who owns the element. <br>
                   If not provided the first player in game will be used</td>
    </tr>
    <tr>
      <td>faketorio.check</td>
      <td>name - the name of the checkbox</td>
      <td rowspan="2">Sets the checkbox state to true<br>
        If the checkbox does not exist or is not a checkbox an exception is thrown.
      </td>
    </tr>
    <tr>
      <td></td>
      <td>player - The player who owns the element. <br>
                   If not provided the first player in game will be used</td>
    </tr>
    <tr>
      <td>faketorio.uncheck</td>
      <td>name - the name of the checkbox</td>
      <td rowspan="2">Sets the checkbox state to false<br>
        If the checkbox does not exist or is not a checkbox an exception is thrown.
      </td>
    </tr>
    <tr>
      <td></td>
      <td>player - The player who owns the element. <br>
                   If not provided the first player in game will be used</td>
    </tr>
  </tbody>
</table>

#### Assertions

The following assertions are provided by faketorio

<table>
  <tbody>
    <tr>
      <th>Function name</th>
      <th>Parameters</th>
      <th>Return value/Action</th>
    </tr>
    <tr>
      <td>faketorio.assert_element_exists</td>
      <td>name - the name of the element</td>
      <td rowspan="2">Returns the element with the given name.<br>
        Throws exception if the element does not exist.
      </td>
    </tr>
    <tr>
      <td></td>
      <td>player - The player who owns the element. <br>
                   If not provided the first player in game will be used</td>
    </tr>
    <tr>
      <td>faketorio.assert_element_not_exists</td>
      <td>name - the name of the element</td>
      <td rowspan="2">Asserts that the element does not exist.<br>
        If the element is found an exception is thrown.
      </td>
    </tr>
    <tr>
      <td></td>
      <td>player - The player who owns the element. <br>
                   If not provided the first player in game will be used</td>
    </tr>
    <tr>
      <td>faketorio.assert_checked</td>
      <td>name - the name of the checkbox</td>
      <td rowspan="2">Asserts that the checkbox is checked.<br>
        If the element is not found or is not a checkbox an exception is thrown.
      </td>
    </tr>
    <tr>
      <td></td>
      <td>player - The player who owns the element. <br>
                   If not provided the first player in game will be used</td>
    </tr>
    <tr>
      <td>faketorio.assert_unchecked</td>
      <td>name - the name of the checkbox</td>
      <td rowspan="2">Asserts that the checkbox is unchecked.<br>
        If the element is not found or is not a checkbox an exception is thrown.
      </td>
    </tr>
    <tr>
      <td></td>
      <td>player - The player who owns the element. <br>
                   If not provided the first player in game will be used</td>
    </tr>
  </tbody>
</table>

#### logging

The log system functions are intended for debug output and if you want to report something to the user 
while the tests are running.

The system knows four different log levels. `TRACE`, `DEBUG`, `INFO` and `WARN`. The default log level is `INFO`.
All messages that are logged with a level lower (read left in the list) as the current log level will be ignored.

Messages passed to the logging system will be printed to every player in Factorio. Additionally it will be written to the `faketorio.log` file
in your Factorio `script-output` folder in your [application directory](https://wiki.factorio.com/Application_directory).

To create log messages use one of the following functions

```lua
-- simple logging
faketorio.log.trace("my test trace message")
faketorio.log.debug("my test debug message")
faketorio.log.info("my test info message")
faketorio.log.warn("my test warn message")

-- logging with parameter expansion (prints "my test pattern wololo.")
faketorio.log.trace("my test pattern %s.", {"wololo"})
faketorio.log.debug("my test pattern %s.", {"wololo"})
faketorio.log.info("my test pattern %s.", {"wololo"})
faketorio.log.warn("my test pattern %s.", {"wololo"})

-- to change the current log level and thus limiting the output during your tests use
faketorio.log.setTrace()
faketorio.log.setDebug()
faketorio.log.setInfo()
faketorio.log.setWarn()
```

#### mocks
Sometimes it is necessary to change the behavior of your mod, pretending certain external events happened.
One example would be the user modified the mod settings. As the `settings` table is read only for the mod we can just mock
the result.

Assuming you have a function like this
```lua
function myMod.is_setting_enabled(player)
    return settings.get_player_settings(player)["my-mod-setting"].value
end

```

we can now change the behavior of that function by mocking it:
```lua
local player = ...
myMod.is_setting_enabled(player) -- returns true (default value)

-- lets create a mock
when(myMod, "is_setting_enabled"):then_return(false)

myMod.is_setting_enabled(player) -- returns false (the mocked value)

myMod.is_setting_enabled:revert()
myMod.is_setting_enabled(player) -- returns true again (it calls the original function)
```

## Credits

Faketorio is inspired by [Factorio stdlib](https://github.com/Afforess/Factorio-Stdlib) and the work Afforess did there to enhance the testing.
Over time I hope to become as complete as this testing system.