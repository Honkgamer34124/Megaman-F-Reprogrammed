extends Timer
var blinktimer=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var main_scene
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	main_scene=get_parent()
	if time_left<wait_time/2:
		blinktimer+=1
		if main_scene!=null:
			if blinktimer%10==1:
				main_scene.visible=true
			elif blinktimer%10==5:
				main_scene.visible=false

func _on_timeout():
	queue_free()
	main_scene.queue_free()
