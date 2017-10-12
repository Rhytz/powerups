# Multi Theft Auto race powerups
Will give the player a special powerup when driving through a marker. 

## How to install
1. Clone the files from this repository into a new folder within the resources folder of your MTA server
2. Include the resource in any maps where you want to use the powerups by including it in the meta.xml of the map
```xml
<include resource="powerups" /> <!-- Where "powerups" is the name of the folder -->
```
3. Add markers to your map with the map editor. The script will automatically hook to all markers within the map.

## Usage
Driving through a marker will give the player a random powerup. They can be activated with <kbd>left ⇧</kbd> or <kbd>right ⇧</kbd>.
Optionally the pickup can be discarded with <kbd>Z</kbd>

## The powerups
![picture alt](https://raw.githubusercontent.com/Rhytz/powerups/master/assets/images/barrels.png "Barrels")

Drops an explosive barrel behind the player's vehicle. When another player is killed by hitting the barrel, it will count as a kill for a player that placed it.

![picture alt](https://github.com/Rhytz/powerups/blob/master/assets/images/boost.png "Quick boost")

Gives the player a quick boost forwards at maximum car weight.

![picture alt](https://github.com/Rhytz/powerups/blob/master/assets/images/invincibility.png "Invincibility")

The players vehicle is invicible for 10 seconds

![picture alt](https://github.com/Rhytz/powerups/blob/master/assets/images/maxweight.png "Max Weight")

The players vehicle has maximum car weight for 10 seconds. It makes it easy to push other players out of the way.

![picture alt](https://github.com/Rhytz/powerups/blob/master/assets/images/mines.png "Mines")

Drops bouncy mines behind the players vehicle

![picture alt](https://github.com/Rhytz/powerups/blob/master/assets/images/ramps.png "Ramps")

Drops ramps behind the players vehicle

![picture alt](https://github.com/Rhytz/powerups/blob/master/assets/images/rockets.png "Rockets")

Lets the player shoot rockets from his vehicle

## Todo
* Add more powerups
* Maybe replace the mine and weight powerups with something more fun
