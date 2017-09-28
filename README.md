# Faketorio
Support library for automated testing of Factorio mods


[![Travis](https://img.shields.io/travis/JonasJurczok/faketorio.svg)](https://travis-ci.org/JonasJurczok/faketorio)

## Purpose
The problem with modding in Factorio (or any other script language based modding environment) is testing.
Usually this is solved by a huge amount of manual testing. This amount grows with every new feature and every bugfix.. because in theory you have to test EVERYTHING EVERY.SINGLE.TIME (super annoying).

This is where automated testing comes in. I'm new to lua testing, but there are [a couple](http://lua-users.org/wiki/UnitTesting) unit testing frameworks available.

To write proper unit tests you need to have roughly the same environment as in the real game. For Factorio this means having access to `global`, `game` etc. Also being able to create a UI inside of your tests helps a lot with testing behaviour (not design unfortunately.. :( )

Enter Faketorio. The next sections will describe alternatives and how to properly use it.


## Installation

If you use [LuaRocks](https://luarocks.org) for your lua modules it is as easy as running `luarocks install faketorio`.

If you do all the dependency management yourself you will have to download the files from this github repo and place them in a convenient location. Then `require` them with the proper path.

## Usage

Faketorio is designed to give you all the objects (and some of the behaviour) of the real game. To achieve this it creates all the necessary global objects for you.

### game

### global

### player

#### gui

### serpent

This is no real magic. It basically provides a serpent instance that you can make global.

### settings


## Credits

Faketorio is inspired by [Factorio stdlib](https://github.com/Afforess/Factorio-Stdlib) and the work Afforess did there to enhance the testing.
Over time I hope to become as complete as this testing system.
