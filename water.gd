extends Area2D


var col_shape:CollisionShape2D
var sprite:Sprite2D
var change:int = 0
@export var change_speed:float = 0.7
@export var minimum_speed:float = 0.3


func _ready() -> void:
	col_shape = $collshape
	sprite = $sprite
	

func _physics_process(delta: float) -> void:
	if (change > 0):
		var amount = change_speed
		change -= change_speed;
		if (change < 0 ):
			amount += change
			change = 0
		go_up(amount)
		return
	if (change < 0):
		var amount = change_speed
		change += change_speed;
		if (change > 0 ):
			amount += change
			change = 0
		go_down(amount)	
		return
	if (change == 0):
		go_up(minimum_speed)





func go_up(amount:float) -> void:
	if (sprite.position.y <= 272):
		return
	col_shape.position.y -= amount;
	sprite.position.y -= amount

func go_down(amount:float) -> void:
	if (sprite.position.y >= 698):
		return
	col_shape.position.y += amount;
	sprite.position.y += amount