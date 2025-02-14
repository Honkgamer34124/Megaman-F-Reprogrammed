extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.in_ladder_zone=true
		#print(area.name)
		if Input.is_action_pressed("move_up"):
			get_tree().call_group("ladder_top_platforms","enter_ladder_disable_cshapes")
			body.climb=true


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.in_ladder_zone=false
#		body.animation_player.play('leave_ladder')
		body.climb=false
		get_tree().call_group("ladder_top_platforms","exit_ladder_enable_chsapes")
