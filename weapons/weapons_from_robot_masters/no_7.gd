extends CharacterBody2D

@export var weapon_to_test_out:String="0"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	pass





func _on_area_2d_area_entered(area):
	if area.is_in_group("player_hitbox"):
		
		GlobalScript.weaponsRunTimeValues[weapon_to_test_out]=true
		GlobalScript.save_energy_weapon_tanks()
		print(name+"(name)-->no. "+weapon_to_test_out+" weapon active")
		queue_free()
