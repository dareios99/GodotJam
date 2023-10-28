extends Sprite2D



func _ready() -> void:
	dissappear()
	
func appear():
	var tweeno = create_tween()
	tweeno.set_ease(Tween.EASE_IN_OUT)
	tweeno.tween_property(self, "modulate:a", 1, 0.7)
	tweeno.tween_callback(dissappear)
	
func dissappear():
	var tweeno = create_tween()
	tweeno.set_ease(Tween.EASE_IN_OUT)
	tweeno.tween_property(self, "modulate:a", 0, 0.7)
	tweeno.tween_callback(appear) 
