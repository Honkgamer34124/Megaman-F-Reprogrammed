extends RigidBody2D
var already_saved=false
@onready var animation_player = $AnimationPlayer
var gravity=980
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not already_saved:
		$AnimatedSprite2D.play("not_saved")
	elif already_saved:
		$AnimatedSprite2D.play("saved_point_temp_i_guess")
#	if not is_on_floor():
#		velocity.y+=gravity*delta
#	move_and_slide()


func _on_body_entered(_body):
	pass


func _on_player_detection_area_2d_body_entered(body):
	pass # Replace with function body.
	if body.is_in_group("player"):
		if not already_saved:
			GlobalScript.player_position_x=$point_save.global_position.x
			GlobalScript.player_position_y=$point_save.global_position.y
			#region Debugging 
			#print(name,"save_point",GlobalScript.player_position_x,$point_save.global_position)
			#endregion
			GlobalScript.save_current_player_checkpoint_position()
			already_saved=true
