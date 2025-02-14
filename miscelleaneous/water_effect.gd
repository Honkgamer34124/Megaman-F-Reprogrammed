extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#print(name+':water effect animation : ready')
	play("water_enter_in")
	$enter_leave_water_mm6.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_finished():
	queue_free()
