extends StaticBody2D
var ontop = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print("ladder_top_platform:get_collision_layer_value:bool:"get_collision_layer_value(4))
	#code above gets the collision_layer_value for the ladder_top_platform
	if ontop == true:
		if Input.is_action_just_pressed("move_down"):
			enter_ladder_disable_cshapes()
			object.animatedSprite2D.play("about_to_leave_ladder")
			object.climb = true


func enter_ladder_disable_cshapes():
	#print('ladder_top_platforms:active_entering..')
	set_collision_layer_value(4, false)


func exit_ladder_enable_chsapes():
	#print('ladder_top_platforms:active_exiting..')
	set_collision_layer_value(4, true)


var object


func _on_player_on_top_detection_body_entered(body):
	if body.is_in_group("player"):
		ontop = true
		object = body


func _on_player_on_top_detection_body_exited(body):
	if body.is_in_group("player"):
		ontop = false
		if body.climb == true and body.velocity.y < 0:
			body.animatedSprite2D.play("about_to_leave_ladder")
