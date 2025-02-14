extends StaticBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_detected_left=false

func _ready():
	$anim.frame=0;$anim2.frame=0

func _physics_process(_delta):
	if $anim.frame==0:
		$CollisionShape2D.disabled=false
	elif $anim.frame!=0:
		$CollisionShape2D.disabled=true
	if $anim2.frame==0:
		$CollisionShape2D2.disabled=false
	elif $anim2.frame!=0:
		$CollisionShape2D2.disabled=true
	#move_and_collide(Vector2(0,0))
#	move_and_slide()
#	velocity.x=0
#	velocity.y=0
	#if player_on_left==
	
	
	
var player_on_left=false;var player_on_right=false
func _on_detect_player_left_body_entered(body):
	if body.is_in_group("player") and is_physics_processing()==true:
		body.isTransitioningToNextRoom=true
		if player_on_left==false:
			player_on_left=true
			$anim.play("door_open_close")
			$anim2.play("door_open_close")
			$door.play()
			#$detect_player_left/CollisionShape2D.disabled=true
	


func _on_detect_player_left_body_exited(_body):
#	if body.is_in_group("player"):
#		player_on_left=false
	pass

func _on_detect_player_right_body_entered(body):
	if body.is_in_group("player") and is_physics_processing()==true:
		if body.velocity.x>0:
			if player_on_right==false:
				player_on_right=true
				$anim.play_backwards("door_open_close")
				$anim2.play_backwards("door_open_close")
				$door.play()
				#$detect_player_right/CollisionShape2D.disabled=true


func _on_detect_player_right_body_exited(body):
	if body.is_in_group("player") and is_physics_processing()==true:
		body.isTransitioningToNextRoom=false
		body.stop=false
