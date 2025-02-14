extends CharacterBody2D


@export var SPEED = 3000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	velocity.y=SPEED*delta
	move_and_slide()


func _on_player_detect_body_entered(body):
	if body.is_in_group('player'):
		body.animatedSprite2D.visible=true
		body.animatedSprite2D.play('spawn')
		#body.isPlayerReady=true
		queue_free()
