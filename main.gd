extends Node2D




func _ready() -> void:
	$water.area_entered.connect(character_in_water.bind(true))
	$water.area_exited.connect(character_in_water.bind(false))
	


func character_in_water(is_entered:bool):
	
		
