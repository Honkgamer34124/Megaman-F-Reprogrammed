extends RigidBody2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $anim

func _ready():
	$anim.play("large_health_capsule")

func _physics_process(delta):
#	if $anim:
#		MegamanItems.chargeeffect($anim)
#	if not is_on_floor():
#		velocity.y += gravity * delta
#	move_and_slide()
	pass


func _on_detect_player_body_entered(body): #checks if a player has hit the capsule
	if body.is_in_group("player"):
		GlobalScript.health+=10
		$healthup.play()
		$detect_player/CollisionShape2D.set_deferred("disabled",true)
		anim.visible=false


func _on_healthup_finished():
	pass # Replace with function body.
	queue_free()
