extends RigidBody2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $anim

func _ready():
	animated_sprite.play("small_health_capsule")

func _physics_process(delta):
	pass


func _on_detect_body_body_entered(body):
	if body.is_in_group("player"):
		GlobalScript.health+=2
		$healthup.play()
		$detect_body/CollisionShape2D.set_deferred("disabled",true)
		animated_sprite.visible=false



func _on_healthup_finished():
	queue_free()

#func delete_collectable():
	#if new_collectable!=null:
		#new_collectable.queue_free()
		#delete_timer.queue_free()
