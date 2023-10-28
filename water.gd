extends Area2D


var col_shape:CollisionShape2D
var sprite:AnimatedSprite2D
var change:int = 0
@export var change_speed:float = 0.7
@export var minimum_speed:float = 0.3
var is_returning_to_normal = true


func _ready() -> void:
	col_shape = $collshape
	sprite = $sprite
	sprite.play("default")
	

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
	if (is_returning_to_normal):
		if sprite.position.y > 760:
			go_up(minimum_speed)
		if sprite.position.y < 760:
			go_down(minimum_speed)


func go_up(amount:float) -> void:
	if (sprite.position.y <= 421):
		return
	col_shape.position.y -= amount;
	sprite.position.y -= amount

func go_down(amount:float) -> void:
	if (sprite.position.y >= 970):
		return
	col_shape.position.y += amount;
	sprite.position.y += amount
