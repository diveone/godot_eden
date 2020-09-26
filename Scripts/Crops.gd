extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _tileset = get_tileset()

# Called when the node enters the scene tree for the first time.
func _ready():
    print_debug("Ready Tileset:")
    print_debug(_tileset)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_Player_plant_crop(pos):
    # Plant a crop on this TileMap at pos
    set_cellv(pos, _tileset.find_tile_by_name("coconut_seed"))
    print_debug("Tile")
    print_debug(pos)
    update_dirty_quadrants()
    print_debug("Update Quadrants")
    print_debug(_tileset)
