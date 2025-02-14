extends enemy


var SPEED = 1200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	
	match state:
		"left":velocity=Vector2(-1,1).normalized()*SPEED
		"right":velocity=Vector2(1,1).normalized()*SPEED
	$timers/lifetime.start()
func _physics_process(delta):
	SPEED=1200
	playerdamage_value=4
	var collision =move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())
	#move_and_slide()


func _on_lifetime_timeout():
	queue_free()
