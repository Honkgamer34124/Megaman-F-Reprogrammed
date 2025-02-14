extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func change_music(old:AudioStreamPlayer2D,new:AudioStreamPlayer2D):
	old.stop()
	new.play()
func stop_music(music_to_be_stopped):
	if music_to_be_stopped is AudioStreamPlayer or music_to_be_stopped is AudioStreamPlayer2D:
		music_to_be_stopped.stop()
#var main_camera;var camera_to_adjust #shadowing of variables,hence disabled
func switch_camera(main_camera:Camera2D,camera_to_adjust:Camera2D):
	main_camera.limit_top=camera_to_adjust.limit_top
	main_camera.limit_bottom=camera_to_adjust.limit_bottom
	main_camera.limit_left=camera_to_adjust.limit_left
	main_camera.limit_right=camera_to_adjust.limit_right
#	var tween=create_tween();#tween.connect('finished',feedback_tween)
#	tween.tween_property(main_camera,"limit_top",camera_to_adjust.limit_top,5)
#	var tween2=create_tween()
#	tween2.tween_property(main_camera,'limit_bottom',camera_to_adjust.limit_bottom,5)
#	var tween3=create_tween()
#	tween3.tween_property(main_camera,'limit_left',camera_to_adjust.limit_left,5)
#	var tween4=create_tween()
#	tween4.tween_property(main_camera,'limit_right',camera_to_adjust.limit_right,5)

# a to be planned old tween for screen transition finishes
#is not being used rn
#func feedback_tween(main_camera,camera_to_adjust):
#	print('tween finished')
#
