extends CharacterBody2D

signal died

@onready var _animated_sprite = $Sprite2D
@onready var _oxygen_progress_bar = $OxygenProgressBar


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

const MAX_OXYGEN_LEVEL = 100
const OXYGEN_DEPLITION_SPEED = 10
const OXYGEN_REFILL_SPEED = 20

var oxygen_level = MAX_OXYGEN_LEVEL

var oxygen_depleed_timer = Timer.new()
var oxygen_refill_timer = Timer.new()

var task_call:Callable  # method to call to initiate a task

var is_electrocuted:bool = false

func _ready():
	_animated_sprite.play("idle")
	
	oxygen_depleed_timer.wait_time = 1
	oxygen_depleed_timer.connect("timeout",self._oxygen_depleed_timer_timeout) 
	
	oxygen_refill_timer.wait_time = 1
	oxygen_refill_timer.connect("timeout",self._oxygen_refill_timer_timeout) 

	add_child(oxygen_depleed_timer)
	add_child(oxygen_refill_timer)

func _oxygen_depleed_timer_timeout():
	if(oxygen_level > 0):
		oxygen_level -= min(OXYGEN_DEPLITION_SPEED, oxygen_level)
		
	_oxygen_progress_bar.value = oxygen_level
	
	if(oxygen_level <= 0):
		oxygen_depleed_timer.stop()
		died.emit()
		
	
func _oxygen_refill_timer_timeout():
	if(oxygen_level < MAX_OXYGEN_LEVEL):
		var level_diff = MAX_OXYGEN_LEVEL - oxygen_level
		oxygen_level += min(level_diff, OXYGEN_REFILL_SPEED)
		
	_oxygen_progress_bar.value = oxygen_level
	
	if oxygen_level == MAX_OXYGEN_LEVEL:

		_oxygen_progress_bar.hide()
		oxygen_refill_timer.stop()

func has_entred_water() :
	_oxygen_progress_bar.value = oxygen_level
	is_in_water = true
	gravity = original_gravity * 0.5
	current_speed = SPEED * 0.7
	current_jump_velocity = JUMP_VELOCITY * 0.9
	
	_oxygen_progress_bar.show()
	oxygen_refill_timer.stop()
	oxygen_depleed_timer.start()
	
func has_exited_water() :
	is_in_water = false
	gravity = original_gravity 
	current_speed = SPEED
	current_jump_velocity = JUMP_VELOCITY
	
	oxygen_depleed_timer.stop()
	oxygen_refill_timer.start()


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
		
	_animated_sprite.set_flip_h( current_direction == 1 )

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor() and is_jumping:
		is_jumping = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_electrocuted:
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
	
	if Input.is_action_just_pressed("activate_task") and !is_electrocuted:
		attempt_task(true)
	if Input.is_action_just_released("activate_task"):
		attempt_task(false)
	

func attempt_task(how:bool): 
	if (task_call.is_null()):
		return
	task_call.call(how)

func electrocute():
	is_electrocuted = true
	get_tree().create_timer(2.0).timeout.connect(func(): is_electrocuted = false)
	do_electrocution()

func do_electrocution():
	if (!is_electrocuted):
		return
	var twee =  create_tween();
	twee.tween_property($Sprite2D, "modulate:r", 0, 0.2)
	twee.tween_property($Sprite2D, "modulate:r", 1, 0.2)
	twee.tween_callback(do_electrocution)
