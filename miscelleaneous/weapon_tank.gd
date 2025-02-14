extends RigidBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animated_sprite_2d.play("w_tank")

func _on_detect_player_body_entered(body):
	if body.is_in_group('player'):
		GlobalScript.weapon_tank_number+=1
		$play_effect.play()
		$detect_player/CollisionShape2D.set_deferred("disabled",true)
		animated_sprite_2d.visible=false
		GlobalScript.save_energy_weapon_tanks()


func _on_play_effect_finished():
	queue_free()
