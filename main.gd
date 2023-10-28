extends Node2D




func _ready() -> void:
	$water.area_entered.connect($CharacterBody2D.has_entred_water)
	$water.area_exited.connect($CharacterBody2D.has_exited_water)
	
