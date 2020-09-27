extends TileMap

var _tileset = get_tileset()

# TODO: Figure out why these variables work, isn't null
var player = PlayerNode
onready var grid = get_node("/root/GridNode")

# Called when the node enters the scene tree for the first time.
func _ready():
    print_debug("Ready Tileset:")
    player.position = Vector2(435, 300)

func _physics_process(delta):
    var player_pos = player.global_position
    var tile_pos_player_is_on = world_to_map(player_pos)
    var tile_pos_infront_of_player = tile_pos_player_is_on + player.face_direction
    grid.global_position = tile_pos_infront_of_player * 32 # tile size
    

func _unhandled_input(event):
    # TODO: this works but the tilemap layers are a problem for displaying it
    if event.is_action_pressed("plant"):
        var player_pos = world_to_map(PlayerNode.position)
        var seed_tile = _tileset.find_tile_by_name("coconut_seed")
        self.set_cellv(player_pos, seed_tile)
    
