extends CharacterBody2D

@onready var _animated_sprite = $Sprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var original_gravity = gravity 

var is_in_water = false
var is_jumping = false

var current_direction = 0
var current_speed = SPEED
var current_jump_velocity = JUMP_VELOCITY

var task_call:Callable  # method to call to initiate a task

func _ready():
	_animated_sprite.play("idle")

func has_entred_water() :
	is_in_water = true
	gravity = original_gravity * 0.5
	current_speed = SPEED * 0.7
	current_jump_velocity = JUMP_VELOCITY * 0.9
	
func has_exited_water() :
	is_in_water = false
	gravity = original_gravity 
	current_speed = SPEED
	current_jump_velocity = JUMP_VELOCITY


func _process(delta):
	var direction = Input.get_axis("left", "right")
	
	if (direction != 0):
		current_direction = direction
	
	if is_jumping:
		var is_going_up = velocity.y < 0
		if is_going_up:
			_animated_sprite.play("jump")
		else:
			_animated_sprite.play("fall")
	else:
		if direction != 0:
			_animated_sprite.play("run")
		else:
			_animated_sprite.play("idle")
		
	_animated_sprite.set_flip_h( current_direction == -1 )

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor() and is_jumping:
		is_jumping = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		velocity.y = current_jump_velocity
				
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("activate_task"):
		attempt_task(true)
	if Input.is_action_just_released("activate_task"):
		attempt_task(false)
	

func attempt_task(how:bool): 
	if (task_call.is_null()):
		return
	task_call.call(how)
