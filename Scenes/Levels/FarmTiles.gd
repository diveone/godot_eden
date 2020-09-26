extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var map_size = 1024

# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            print("Left button was clicked at ", event.position)
            # Get player action when they clicked
            # Display game actions menu
            
        if event.button_index == BUTTON_WHEEL_UP and event.pressed:
            print("Wheel up")
