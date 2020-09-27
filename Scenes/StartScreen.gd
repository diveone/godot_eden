extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT:
            print("click")
            get_tree().change_scene("res://Scenes/Levels/Gabor.tscn")

