extends enemy


const SPEED = 20000.0
const JUMP_VELOCITY = -400.0
@export var initial_x_direction="left"
#@export var state=1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	playerdamage_value=1
	health=1
	
func _physics_process(delta):
	match initial_x_direction:
		"left":
			match state:
				1:
					velocity.x=-SPEED*delta
				2:
					velocity.x=-SPEED*delta
					velocity.y=-SPEED*delta
				3:
					velocity.x=-SPEED*delta
					velocity.y=SPEED*delta
		"right":
			match state:
				1:
					velocity.x=SPEED*delta
				2:
					velocity.x=SPEED*delta
					velocity.y=-SPEED*delta
				3:
					velocity.x=SPEED*delta
					velocity.y=SPEED*delta
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_detect_player_body_entered(body):
	if  body is TileMap or body.is_in_group("player"):
		queue_free()
		pass


func _on_detect_player_area_entered(_area):
	pass
