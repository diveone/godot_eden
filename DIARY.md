# Dev Diary

Features:
1. Farming
2. Crafting
3. Exploration

## Collision

This seems mostly managed by signals. Some object emits a signal and other objects can receive it via the `connect()` method. Signals can pass information as well via arguments.

* [Signals](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#signals)

```gdscript
# In Player.gd
signal collided_with(obj)

func some_function():
    var collision = move_and_collide()
    emit("collided_with", collision)
```

In this example, the player simply emits information. It doesn't handle the collision. And this seems idle. Objects should jsut go about their business, while emitting signals that allow other objects to interact with it.

I can have a Tilemap listen for this signal to respond to the players collision.

```gdscript
# MyTileMap.gd

func _on_Player_collided_with(obj):
    if obj.collider is TileMap:
        # Subtract players position from the normal to get the exact
        # tile that it collided with
        tile_pos = obj.collider.world_to_map($Player.position)
        tile_pos -= obj.collider.normal
        # Get the cell for that tile
        var tile = obj.collider.get_cellv(tile_pos)
        set_cellv(tile_pos, some_tile_id)
```

How to make farm tiles that have collision which doesn't stop the player from walking on the tile? Do the farm tiles have to emit a signal when the player touches them?


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

## TileMaps and TileSets

`TileMap.set_cellv(vector, tile_id)`
Tilemaps are where tiles are painted. This method sets a map cell to the given tile.

`Tileset.tile_set_texture(tile_id, texture)`
Is this similar to `set_cellv()`?


- A `TileMap` can only have 1 tileset.
- A `Scene` can have multiple tilemaps; the order of tilemaps stacks.
- A `TileMap.tile_set` has global settings
- Each tile in a `tile_set` can be named and have custom settings.


### How to create `.tres` resources

Assuming you have a sheet of tiles you'd like to use, and you've placed it somewhere in the project directory (it doesn't matter which folder, as long as it's in the project), follow these steps.

1. Drag your tile sheet from the **FileSystem** window into the **TileSet** window
2. Create your tiles (see section to learn how to Create Tiles).
3. Look in the **Inspector** while you have the **TileSet** window active and click the tool icon at the top right.
4. Click "Save ..."


### Bitmasks

Required when using Autotile. The red area defines an area that can be joined with the other autotiles. 

### Sorting with tilemaps

Objects must be direct children of the YSort node. There doesn't appear to be a programmatic way to add nodes to it, as `Node.add_child` doesn't do anything that I can tell.

Some tilemaps needed to have "Centered Texture" box set to `true` in order to have the walk behind/front feature.


Autoload
---------

Neat feature to autoload any scenes automatically and access them programmatically in any script. One use is to autoload the player on a given level and position them where you want.

Using this means if a scene is autoloaded AND manually loaded, you'll have two of that item on your scene. How does this "singleton" work?


Character Movement & Controls
------------------------------

To "face" the character:

|    up  |  down   |  left   | right  |
| ------ | ------- | ------- | ------ |
| (0, 1) | (0, -1) | (-1, 0) | (1, 0) |

### Actions

TIL about actions! In the Project Settings > Input screen you can define any action and associate with with a keyboard press. For starters, things like "ui_down" are there by default.

But if I want an action such as "attack", I can create that as well. Crucially, this allows me to use actions directly instead of checking for key presses:

```gdscript
func _input(event):
    if event.is_action_pressed("attack"):
        # do some stuff 
```

Sharing and Global Objects
--------------

The Autoload feature helps make objects available globally. You can use them by simply invoking the name given to it.

Its better to use `get_node()` than to call it directly, as I've gotten mixed results.

```gdscript
# SomeScript.gd

# direct invocation seems to work sometimes and not others
var my_auto_module = MyAutoModule

# Safely works all the time:
onready var my_auto_module = get_node("root/MyAutoModule")
```
`onready` is a shorthand for initializing the variable with the `_ready()` method.

The direct invocation caused a null error, as 'my_auto_module' was considered null.

- [onready](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html#onready-keyword)

At the same time, similar code within a script for a `TileMap` worked just fine without `get_node()`. Both 'player' and 'grd' were originally defined as the first variable. But the script worked with either format. No null errors.

```python
var player = PlayerNode
onready var grid = get_node("/root/GridNode")
```

It doesn't seem related to the `TileMap` variables using inherited properties from `Node`. But then realized I was using a custom property for 'player', so that couldn't be right.

Not sure what's going  on there.