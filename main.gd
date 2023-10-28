extends Node2D




func _ready() -> void:
	
	$water.body_entered.connect(body_in_water.bind(true))
	$water.body_exited.connect(body_in_water.bind(false))
	
	
func body_in_water(body, entered:bool):
	
	if (body is CharacterBody2D):
		if (entered):
			body.has_entred_water()
		else:
			body.has_exited_water()

