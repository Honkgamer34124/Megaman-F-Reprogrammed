extends RigidBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if MegamanItems.weapon_number==0:
		MegamanItems.chargeeffect(animated_sprite_2d)
	elif MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
		MegamanItems.change_color_palette(animated_sprite_2d)

func _process(_delta):
	animated_sprite_2d.play("e_tank")
	if MegamanItems.weapon_number==0:
		MegamanItems.chargeeffect(animated_sprite_2d)
	elif MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
		MegamanItems.change_color_palette(animated_sprite_2d)


func _on_detect_player_body_entered(body):
	if body.is_in_group('player'):
		GlobalScript.energy_tank_number+=1
		$play_effect.play()
		$detect_player/CollisionShape2D.set_deferred("disabled",true)
		animated_sprite_2d.visible=false
		GlobalScript.save_energy_weapon_tanks()


func _on_play_effect_finished():
	queue_free()
