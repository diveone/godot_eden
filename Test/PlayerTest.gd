extends Area2D

export var speed = 100  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

func _ready():
    screen_size = get_viewport_rect().size
    
func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
        $Sprite.animation = "walk_right"
        $Sprite.flip_h = false
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
        $Sprite.animation = "walk_right"
        $Sprite.flip_h = true
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
        $Sprite.animation = "walk_down"
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
        $Sprite.animation = "walk_up"
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $Sprite.play()
    else:
        # TODO: When player stops, use standing frame facing current direction
        $Sprite.stop()

    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

const MOTION_SPEED = 160 # Pixels/second.

func _physics_process(_delta):
    var motion = Vector2()
    motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    motion.y /= 2
    motion = motion.normalized() * MOTION_SPEED
    #warning-ignore:return_value_discarded
    #move_and_collide(motion)
