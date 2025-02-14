extends RigidBody2D
@onready var animated_sprite = $anima

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	MegamanItems.chargeeffect($anima)

func _physics_process(delta):
	if MegamanItems.weapon_number==0:
		MegamanItems.chargeeffect($anima)
	elif MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
		MegamanItems.change_color_palette($anima)
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#	move_and_slide()


func _on_detect_player_body_entered(body):
	if body.is_in_group("player"):
		$detect_player/CollisionShape2D.set_deferred("disabled",true)
		animated_sprite.visible=false
		$healthup.play()
		if MegamanItems.weapon_number!=0:
			if MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
				pass
				MegamanItems.weapon_energy[MegamanItems.weapon_number]+=2


func _on_healthup_finished():
	queue_free()
