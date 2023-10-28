extends CharacterBody2D

@onready var _animated_sprite = $Sprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var original_gravity = gravity 

var is_in_water = false

var current_direction = 0

func _ready():
	_animated_sprite.play("idle")

func has_entred_water() :
	is_in_water = true
	gravity *= 0.9
	
func has_exited_water() :
	is_in_water = false
	gravity = original_gravity 


func _process(delta):
	var direction = Input.get_axis("left", "right")
	
	if (direction != 0):
		current_direction = direction

	if direction != 0:
		_animated_sprite.play("run")
	else:
		_animated_sprite.play("idle")
		
	_animated_sprite.set_flip_h( current_direction == -1 )

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
		

	move_and_slide()
