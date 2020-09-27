extends KinematicBody2D

# PLAYER SETTINGS
export var speed = 100  # How fast the player will move (pixels/sec).

# SIGNALS
# Emit signal on a soil tile when the player presses C while next to it
signal plant_crop(collider)


# PLAYER PROPERTIES
var screen_size  # Size of the game window.
var is_farming = false
var face_direction = Vector2()

const MOTION_SPEED = 160 # Pixels/second.
const FACE_RIGHT = Vector2(1, 0)
const FACE_LEFT = Vector2(-1, 0)
const FACE_UP = Vector2(0, -1)
const FACE_DOWN = Vector2(0, 1)
const IDLE = {
    FACE_DOWN: "idle_down", 
    FACE_UP: "idle_up",
    FACE_RIGHT: "idle_right",
    FACE_LEFT: "idle_left"
}


onready var anim = get_node("AnimatedSprite")
onready var act = get_node("/root/Actions")

# Using this variable within _process(d) in place of the local velocity var
# results in the character sliding to the first direction pressed indefinitely
# This may be due to the method being called each frame with a new Vector2.
# var player_velocity = Vector2()  # The player's movement vector.


func _ready():
    screen_size = get_viewport_rect().size
    
# func _process(delta):
#     get_movement(delta)

func get_movement(delta):
    var velocity = Vector2()  # The player's movement vector.
    var input_direction = Vector2(
        int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
        int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
    )
    
    if Input.is_action_pressed(act.WALK_RIGHT):
        velocity.x += 1
        face_direction = FACE_RIGHT
        anim.play("walk_right")
        anim.flip_h = false
    if Input.is_action_pressed(act.WALK_LEFT):
        velocity.x -= 1
        face_direction = FACE_RIGHT  # due to h_flip, keep right
        anim.play("walk_right")
        anim.flip_h = true
    if Input.is_action_pressed(act.WALK_DOWN):
        velocity.y += 1
        face_direction = FACE_DOWN
        anim.play("walk_down")
    if Input.is_action_pressed(act.WALK_UP):
        velocity.y -= 1
        face_direction = FACE_UP
        anim.play("walk_up")
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        anim.play()
    else:
        # TODO: When player stops, use standing frame facing current direction
        # Player starts out looking down (at you)
        anim.play(IDLE.get(face_direction, "idle_down"))

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

func _physics_process(_delta):
    get_movement(_delta)
    var motion = Vector2()
    motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    motion.y /= 2
    motion = motion.normalized() * MOTION_SPEED

    
    #warning-ignore:return_value_discarded
    var player_collision = move_and_collide(motion)
    if player_collision && is_farming:
        print_debug(is_farming)
        handle_farming(player_collision)

func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            print("Left button was clicked at ", event.position)
    elif event is InputEventKey:
        if event.is_action_pressed("plant"):
            print("Plant pressed.")
            is_farming = true
            # emit_signal("plant_crop", position)

func handle_farming(col):
    """Handle planting crops by emitting collider."""
    print_debug("Handle farming called.")
    # emit_signal("plant_crop", col)

