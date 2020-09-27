extends Node2D


var player_spawn = Vector2(430, 300)

# Called when the node enters the scene tree for the first time.
func _ready():
    # var player = get_node("YSort/Player")
    var crops = get_node("YSort/Crops")
    PlayerNode.connect("plant_crop", crops, "_on_Player_plant_crop")
    # FIXME: Works except the player is layered beneath the tiles. add_child not working
    PlayerNode.position = player_spawn
    $YSort.add_child(PlayerNode)
