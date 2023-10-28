extends Area2D
class_name Reactor

signal Meltdown

const MELT_TIME_LIMIT = 10

var melt_time = 0

var melt_timer = Timer.new()

@onready var _count_down_label = $CountDownLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	melt_timer.wait_time = 1
	melt_timer.connect("timeout",self._melt_timer_timeout) 

	add_child(melt_timer)

func is_covered_with_water():
	print("reactor in water")
	melt_timer.stop()
	melt_time = 0
	_count_down_label.hide()
	
func is_not_covered_with_water():
	print("reactor outside water")
	melt_timer.start()
	_count_down_label.show()
	_update_count_down_label()
	
	
func _melt_timer_timeout():
	melt_time += 1
	_update_count_down_label()
	if(melt_time == MELT_TIME_LIMIT):
		_count_down_label.hide()
		melt_timer.stop()
		Meltdown.emit()


func _update_count_down_label():
	_count_down_label.text = str(MELT_TIME_LIMIT - melt_time)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
