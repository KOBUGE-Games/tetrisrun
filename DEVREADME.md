# DEV

## Project architecture

### Files

* DEVREADME.md : File for developers and contributors to coordinate their brave effort
* LICENSE : the license file...
* README.md : File displayed on github

### Folders

* audio : contains all audio files
* gfx : contains all images
* level : contains scenes and scripts and tilesets related to the level
* main : contains general scenes and scripts such as the main scene and global autoload
* menu : contains scenes ans scripts related to user interfaces
* runner : contains scenes and scripts related to the runner

## Technical choices

* Runner stays at horizontal coordinate 0, the environment moves. Tests have to be done to know what type of physics node runner needs to be.

## Notes

* Fixed level is here as a testing mean, the endless level will be the actual gameplay

## Arbitrary choices

This section is to document arbitrary choices who may be reworked

* Screen is 1024x600, default
* Runner is 32x32
* Tiles are 32x32
* Runner starts at 150,395, allowing ~11 tiles under it

## Placeholder art

This section is to document arts which aren't meant to be definitive but just here as placeholder

* Nothing right now, barring any finish-ups

## TODO 

Refer to [the issues](https://github.com/KOBUGE-Games/tetrisrun/issues)
