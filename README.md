# Trainer

Each section walks through notes for different parts of the Godot editor.


## Tilemaps

- A `TileMap` can only have 1 tileset.
- A `Scene` can have multiple tilemaps; the order of tilemaps stacks.
- A `TileMap.tile_set` has global settings
- Each tile in a `tile_set` can be named and have custom settings.

### How to create tilemaps

Assuming you have a sheet of tiles you'd like to use, and you've placed it somewhere in the project directory (it doesn't matter which folder, as long as it's in the project), follow these steps.

1. Create a new `TileMap`
2. In the Inspector: _TileMap > Tile Set > New Tileset ..._
3. Click the _Tile Set_ field with the new tileset.
4. Drag your tile sheet from the **FileSystem** window into the **TileSet** window
5. Create your tiles (see section to learn how to Create Tiles).
6. Look in the **Inspector** while you have the **TileSet** window active and click the tool icon at the top right.
7. Click "Save ..."


### Bitmasks

Required when using Autotile. The red area defines an area that can be joined with the other autotiles. 

### Sorting with tilemaps

Objects must be direct children of the YSort node. There doesn't appear to be a programmatic way to add nodes to it.

Some tilemaps needed to have "Centered Texture" box set to `true` in order to have the walk behind/front feature.


### Autoload

Neat feature to autoload any scenes automatically and access them programmatically in any script. One use is to autoload the player on a given level and position them where you want.

Using this means if a scene is autoloaded AND manually loaded, you'll have two of that item on your scene. How does this "singleton" work?