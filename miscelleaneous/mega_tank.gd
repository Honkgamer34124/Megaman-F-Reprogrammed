extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("mega_tank")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_detect_player_body_entered(body):
	pass # Replace with function body.
	if body.is_in_group("player"):
		pass
		$AnimatedSprite2D.visible=false
		GlobalScript.mega_tank_number+=1
		$healthup.play()
		$detect_player/CollisionShape2D.set_deferred('disabled',true)


func _on_healthup_finished():
	queue_free()
