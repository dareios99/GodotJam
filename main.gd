extends Node2D

var tasks = []
var danger_level = 0;
var timer:Timer


func _ready() -> void:
	
	$water.body_entered.connect(body_in_water.bind(true))
	$water.body_exited.connect(body_in_water.bind(false))
	tasks = $task_container.get_children()
#	timer = Timer()
#	timer.one_shot = false
#	timer.start(3)
#	timer.timeout.connect( func(): danger_level += 1 )
	get_tree().create_timer(7).timeout.connect(check_for_tasks)
	
	
func body_in_water(body, entered:bool):
	if (body is CharacterBody2D):
		if (entered):
			body.has_entred_water()
		else:
			body.has_exited_water()


func check_for_tasks() -> void:
	var task = tasks.pick_random()
	
