extends KinematicBody2D

export var speed = 100  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
const MOTION_SPEED = 160 # Pixels/second.
# Using this variable within _process(d) in place of the local velocity var
# results in the character sliding to the first direction pressed indefinitely
# This may be due to the method being called each frame with a new Vector2.
# var player_velocity = Vector2()  # The player's movement vector.

# Emit signal on a soil tile when the player presses C while next to it
signal plant_crop(crop_position)

func _ready():
    screen_size = get_viewport_rect().size
    
func _process(delta):
    get_movement(delta)
    
    # position += velocity * delta
    # position.x = clamp(position.x, 0, screen_size.x)
    # position.y = clamp(position.y, 0, screen_size.y)

func get_movement(delta):
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
        $AnimatedSprite.animation = "walk_right"
        $AnimatedSprite.flip_h = false
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
        $AnimatedSprite.animation = "walk_right"
        $AnimatedSprite.flip_h = true
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
        $AnimatedSprite.animation = "walk_down"
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
        $AnimatedSprite.animation = "walk_up"
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        # TODO: When player stops, use standing frame facing current direction
        $AnimatedSprite.stop()

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

func _physics_process(_delta):
    var motion = Vector2()
    motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    motion.y /= 2
    motion = motion.normalized() * MOTION_SPEED
    #warning-ignore:return_value_discarded
    var player_collision = move_and_collide(motion)
    if player_collision:
        get_action(player_collision.collider)

func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            print("Left button was clicked at ", event.position)
    elif event is InputEventKey:
        if event.scancode == KEY_C:
            print("C key pressed.")
            emit_signal("plant_crop", position)

func get_action(collider):
    print(collider)
