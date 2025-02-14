extends RigidBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $anim


func _physics_process(delta):
	if MegamanItems.weapon_number==0:
		MegamanItems.chargeeffect($anim)
	elif MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
		MegamanItems.change_color_palette($anim)
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#	move_and_slide()


func _on_detect_body_body_entered(body):
	if body.is_in_group("player"):
		GlobalScript.life+=1
		$healthup.play()
		$detect_body/CollisionShape2D.set_deferred("disabled",true)
		animated_sprite.visible=false
		


func _on_healthup_finished():
	queue_free()
