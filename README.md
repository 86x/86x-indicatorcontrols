# 86x-indicatorcontrols

Description: Allows players of FiveM (which allows custom online servers for GTA 5 on PC) to control the indicators of a vehicle. The key presses that control this are fully and easily customizable using configuration variables.

## Features

 - Turn left or right indicator on using a key/controller button
 - Turn hazard lights (both indicators at once) on using a key/controller button
 - Synchronized across all players of your server
 - If the right indicator is on and you turn on the left indicator, only the left indicator will continue flashing and the right indicator is turned off automatically (and vice versa)
 - If the hazard lights are on, you cannot turn off just the right or left indicator alone (until you turn off the hazard lights again)
 - If you mess up any of the configuration variables, the script will just show an error message (which you can view by pressing F8 [by default] in the game)
 - To turn off the indicators, just press the corresponding control button again (if hazard lights are on, you need to press the hazard lights control to turn them off)
 - **Customize which button controls: left indicator, right indicator, hazard lights**

![Preview screenshot](https://i.imgur.com/anzkusT.png)

## Setup

 - Download the latest release from the releases page. 
 - Put the **folder  *with the files inside*** called "86x-indicatorcontrols" inside of your cfx-server-data/resources/ folder
 - In your resources.cfg (or if you don't have this file, then in your server.cfg) add a new line containing this:
```
ensure 86x-indicatorcontrols
```

## Usage
When using the default configuration you can toggle the indicators like this:
 - Left indicator: LEFT ARROW on the keyboard or DPAD LEFT on a controller
 - Right indicator: RIGHT ARROW on the keyboard OR DPAD RIGHT on a controller
 - Hazard lights: UP ARROW on the keyboard OR DPAD UP

## Customizing the control buttons

 - Go into this folder in your server: cfx-server-data/resources/86x-indicatorcontrols/ and open the file fxmanifest.lua
 - Change the numeric values inside of the quotes in these three lines (not the ones starting with "--"):
```
control_indicator_left  "174"
control_indicator_right  "175"
control_indicator_hazardlights  "172"
```
- Change these values to your desire. Get values for other key controls here: [https://docs.fivem.net/docs/game-references/controls/](https://docs.fivem.net/docs/game-references/controls/)

## Please note
Please note that on a lot of vehicles, you can barely see the indicators during the day. There are mods out there that try to fix this problem. The screenshot above was taken without any of these mods in action (but during the night time obviously).

## Resmon

This resource/mod does not consume much resources as you can see in this screenshot below.
![resmon 86x-indicatorcontrols](https://i.imgur.com/kCOnlue.png)
