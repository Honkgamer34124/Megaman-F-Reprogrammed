extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	GlobalScript.custom_change_scene_function("res://stages/8_main_stages/acidman_stage.tscn") #testing switching to a new scene/stage
	#via a screen transition
