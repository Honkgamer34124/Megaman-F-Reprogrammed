extends enemy
@onready var joe_bot_projectile = $JoeBotProjectile

@export var SPEED = 50000.0
var direction=''
func _ready():
	playerdamage_value=4

func _physics_process(delta):
	match direction:
		'left':
			joe_bot_projectile.flip_h=false
			velocity.x=-SPEED*delta
		'right':
			joe_bot_projectile.flip_h=true
			velocity.x=SPEED*delta
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hitbox_body_entered(body):
	if body.is_in_group('player') or body.is_class('TileMap'):
		queue_free()
