extends Area2D
class_name WorkerTask

@export_file("*.png") var task_image
@export_enum("open_pipes", "close_pipes", "repair_leak", "repair_electricity") var type_of_task;

signal TaskCompleted
signal ProduceWater
signal ConsumeWater
signal ElectricShcok



var is_active := false
var is_working:= false
var work_done:int = 0;
var iter:int = 0

func _ready() -> void:
	var textu = load(task_image)
	$Sprite2D.texture = textu
	
func _process(delta: float) -> void:
	if (!is_active):
		return
	
	iter += 1
	if (iter < 10):
		return
	iter = 0
			
	if (is_working):
		work_done += 1
		$TextureProgressBar.value = work_done
		if (work_done == 20):
			task_completed()
	
		
func _on_body_entered(body: Node2D) -> void:
	if (body is CharacterBody2D):
		body.task_call = execute_task

func _on_body_exited(body: Node2D) -> void:
	if (body is CharacterBody2D):
		body.task_call = Callable()
		is_working = false

func activate_task():
	$warning.visible = true
	is_active = true
	get_tree().create_timer(3).timeout.connect(on_effect_timer)
	
func on_effect_timer()-> void:
	if !is_active:
		return;
	var cooldown = randi_range(2, 5);
	
	match (type_of_task):
		0: #"open_pipes":
			ConsumeWater.emit()
		1: #"close_pipes":
			ProduceWater.emit()
			$water_particles.emitting = true
		2: #"repair_leak": 
			ConsumeWater.emit()
			$water_particles.emitting = true
		3: #"repair_electricity":
			ElectricShcok.emit()
			cooldown += 2
			pass
	get_tree().create_timer(3).timeout.connect(on_effect_timer)

func execute_task(activate:bool):
	if (!is_active):
		return
	is_working = activate

func task_completed() -> void:
	work_done = 0;
	$TextureProgressBar.value = work_done
	is_working = false
	is_active = false
	$warning.visible = false
	TaskCompleted.emit(self)	
	print("task completed!")
	#"open_pipes", "close_pipes", "repair_leak", "repair_electricity"
	match(type_of_task):
		0:
			open_pipes()
		1:
			close_pipes()
		2:
			repair_leak()
		3:
			repair_electricity()

func open_pipes() -> void:
	pass
	
func close_pipes() -> void:
	$water_particles.emitting = false
			
func repair_leak() -> void:
	$water_particles.emitting = false

func repair_electricity() -> void:
	pass
