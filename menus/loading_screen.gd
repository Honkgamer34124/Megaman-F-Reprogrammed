extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused=false
	GlobalScript.restarted_stage=false
	#GlobalScript.robot_master_option=5 #temporal fix fro now
	var tween=create_tween()
	tween.tween_property($loading_progress_bar,"value",$loading_progress_bar.max_value,1)
	tween.connect("finished",loaded_bar_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func loaded_bar_finished():
	match GlobalScript.robot_master_option:
		3:
			print("loading screen: loaded intro scene")
			GlobalScript.life=3
			get_tree().change_scene_to_file("res://stages/intro_stage.tscn")
		5:
			GlobalScript.life=3
			get_tree().change_scene_to_file("res://stages/test_stage_1.tscn")
