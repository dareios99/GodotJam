extends Area2D
class_name WorkerTask

@export_file("*.png") var task_image
@export_enum("open_pipes", "repair_leak", "repair_electricity") var type_of_task;

var is_active := false
var is_working:= false
var work_done:int = 0;
var iter:int = 0

func _ready() -> void:
	activate_task() # testing
	var textu = load(task_image)
	$Sprite2D.texture = textu
	
func _process(delta: float) -> void:
	iter += 1
	if (iter < 10):
		return
	iter = 0
			
	if (is_working):
		work_done += 1
		$TextureProgressBar.value = work_done
		print(work_done)
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
	print("task completed!")
	match(type_of_task):
		"open_pipes":
			open_pipes()
		"repair_leak":
			repair_leak()
		"repair_electricity":
			repair_electricity()

func open_pipes() -> void:
	pass
	
func repair_leak() -> void:
	pass

func repair_electricity() -> void:
	pass
