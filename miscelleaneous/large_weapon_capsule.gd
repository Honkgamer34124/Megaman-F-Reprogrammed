extends RigidBody2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $anim

func _ready():
	$anim.play("large_health_capsule")
	MegamanItems.chargeeffect($anim)

func _physics_process(delta):
#	var megaman=get_parent().get_node('megaman')
#	if megaman:
#		megaman.chargeeffect()
	if MegamanItems.weapon_number==0:
		MegamanItems.chargeeffect($anim)
	elif MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
		MegamanItems.change_color_palette($anim)
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#	move_and_slide()


func _on_detect_player_body_entered(body):
	if body.is_in_group("player"):
		$healthup.play()
		$detect_player/CollisionShape2D.set_deferred("disabled",true)
		animated_sprite.visible=false
		if MegamanItems.weapon_number!=0:
			if MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
				pass
				MegamanItems.weapon_energy[MegamanItems.weapon_number]+=10


func _on_healthup_finished():
	queue_free()
