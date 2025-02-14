extends Node2D
@onready var timer= $dash_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_dash(dur):
	timer.wait_time=dur
	timer.start()

func is_dashing():
	return not timer.is_stopped()
