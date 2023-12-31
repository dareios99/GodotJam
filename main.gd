extends Node2D

var tasks:Array[WorkerTask] =[]
var danger_level = 1;
var timer:Timer

var has_task_that_removes_water:= false
var has_task_that_adds_water:= false

func _ready() -> void:
	
	$water.body_entered.connect(body_in_water.bind(true))
	$water.body_exited.connect(body_in_water.bind(false))
	
	$water.area_entered.connect(reactor_in_water.bind(true))
	$water.area_exited.connect(reactor_in_water.bind(false))
	$reactor.Meltdown.connect(explode)
	
	$CharacterBody2D.died.connect(asfixiate)
	$CharacterBody2D.OxygenLow.connect(onOxygenUpdate)
	
	for child in $task_container.get_children():
		if (child is WorkerTask):
			tasks.append(child)
			child.ConsumeWater.connect(on_consume_water)
			child.ElectricShcok.connect(on_electric_shock)
			child.ProduceWater.connect(on_produce_water)
	for task in tasks:
		task.TaskCompleted.connect(on_task_completed)
	#danger level timer
	timer = Timer.new()
	timer.one_shot = false
	add_child(timer)
	timer.start(3)
	timer.timeout.connect( func(): danger_level += 1 )
	# check for tasks timer
	get_tree().create_timer(7).timeout.connect(check_for_tasks)
	
	
	
func body_in_water(body, entered:bool):
	if (body is CharacterBody2D):
		if (entered):
			body.has_entred_water()
		else:
			body.has_exited_water()

func reactor_in_water(area, entered:bool):
	if (area is Reactor):
		if (entered):
			area.is_covered_with_water()
		else:
			area.is_not_covered_with_water()

func check_for_tasks() -> void:
	tasks.shuffle()
	for task in tasks:
		if task.is_active:
			continue
		# enum values: ("open_pipes", "close_pipes", "repair_leak", "repair_electricity"
		if (has_task_that_adds_water): # close_pipes, 
			if (task.type_of_task == 0 or task.type_of_task == 2):
				continue
			
		if (has_task_that_removes_water): # open_pipes, repair leak
			if (task.type_of_task == 1 ): 
				continue
		task.activate_task()
		if (task.type_of_task == 0 or task.type_of_task == 2):
			has_task_that_removes_water = true
		if (task.type_of_task == 1 ):
			has_task_that_adds_water = true
		if (task.type_of_task != 3):
			$water.is_returning_to_normal = false
		break
		
	var random_time = randi_range(7, 12)
	random_time -= danger_level / 10
	if (random_time < 3):
		random_time = 3
	get_tree().create_timer(random_time).timeout.connect(check_for_tasks)
	
func on_task_completed(task:WorkerTask) -> void:
	# enum values: ("open_pipes", "close_pipes", "repair_leak", "repair_electricity"
	if (task.type_of_task == 1):
		has_task_that_adds_water = false
	if (task.type_of_task == 0 or task.type_of_task == 2):
		var another_present = false
		for taska in tasks:
			if (!taska.is_active):
				continue
			if (taska.type_of_task == 0 or taska.type_of_task == 2):
				another_present = true
		if (!another_present):
			has_task_that_removes_water = false
	
	for tasku in tasks:
		if (tasku.is_active and tasku.type_of_task != 3): # if not electric shock, water is still changing
			return
	$water.is_returning_to_normal = true

func on_consume_water():
	print("consume water")
	$water.change -= 50

func on_produce_water():
	print("produce waater")
	$water.change += 50
	
func on_electric_shock():
	print("electric shock")
	$CharacterBody2D.electrocute()
	pass

func explode():
	var tween = create_tween()
	$explosion.visible = true
	$explosion.modulate.a = 0
	$Label.text = "Meltdown!"
	tween.tween_property($explosion, "modulate:a", 1, 1.5)
	tween.tween_callback(func(): $Label.visible = true)
	get_tree().create_timer(4).timeout.connect(func(): get_tree().change_scene_to_file("res://initial.tscn"))
	

func asfixiate():
	var tween = create_tween()
	$asfiixiia.visible = true
#	$asfiixiia.modulate.a = 0
	$Label.text = "Asphyxiated!!"
	tween.tween_property($asfiixiia, "modulate:a", 1, 1.5)
	tween.tween_callback(func(): $Label.visible = true)
	get_tree().create_timer(4).timeout.connect(func(): get_tree().change_scene_to_file("res://initial.tscn"))

func onOxygenUpdate(amount:int):
	var target = 0
	var tween = create_tween()
	if (amount > 25):
		tween.tween_property($asfiixiia, "modulate:a", 0, 0.6)
	else:
		tween.tween_property($asfiixiia, "modulate:a", 1, 3.0)
	
