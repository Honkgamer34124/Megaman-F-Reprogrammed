extends Path2D

var speed=300
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#constant_linear_velocity.x=speed*delta
	if GlobalScreenTransitionTimer.time_left>0:
		#set_physics_process(false)
		$AnimationPlayer.pause()
	else:
		$AnimationPlayer.current_animation="move"
	pass


func _on_timer_timeout():
	if speed==abs(speed):
		speed=-abs(speed)
	elif speed==-abs(speed):
		speed=abs(speed)
