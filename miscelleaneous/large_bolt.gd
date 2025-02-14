extends RigidBody2D

func _on_detect_player_area_2d_body_entered(body):
	if body.is_in_group('player'):
		queue_free()
		GlobalScript.bolt_number+=20
		
