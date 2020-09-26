# Dev Diary

Features:
1. Farming
2. Crafting
3. Exploration


## Farming

Farming works like so:

* The player prepares some soil (`prepared_soil`)
* Cultvation options:
    - With the players position is touching `prepared_soil`, they can plant crop seeds in it of any kind.
    - Player clicks any tile and it opens an option menu at the mouse location: Prepare Soil, Plant <seed>, Water, Fertilize (this menu should be context sensitive so that only valid options are displayed)
* Seeds are stored in the players inventory or storages. As long as they own it, they can use it.

Seeds could be programmed to sprout basedon time elapsed. Or use days ingame. If turn based, itll be simple to have the crops grow dynamically.

### How do crops work?

Imagine a `Crop` object that tracks crop name, type, sprite image, and time to harvest, and current phase. The phase tracks the stage of growth for the crop. Time to harvest is a number value of how many days it takes for it to develop from seed to food. The sprite image should rotate with the phase, so that it visibly grows to the player.

When the crop is near time to harvest, if the its tall enough, it should animate with player proximity and/or wind/weather. Just a gentle sway from side to side and a rustle.
