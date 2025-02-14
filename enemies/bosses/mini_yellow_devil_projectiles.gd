extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer


const SPEED = 30000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var state="";
var projectile=""

func _ready():
	pass
	$AnimatedSprite2D.play("normal")
	playerdamage_value=3
	match projectile:
		'normal':
			animation_player.play("normal")
		'pinch':
			animation_player.play("pinch")
			if state=="left":
				velocity.x=-SPEED*0.1#$AnimatedSprite2D.position=Vector2(22.333,0)
			elif state=='right':
				velocity.x=SPEED*0.1#$AnimatedSprite2D.position=Vector2(-22.333,0)


func _physics_process(delta):
	match state:
		"left":
			animated_sprite_2d.flip_h=true
			
		"right":
			animated_sprite_2d.flip_h=false
			
	match projectile:
		"normal":
			playerdamage_value=3
			animated_sprite_2d.play("normal")
			animation_player.play("normal")
			if state=="left":
				velocity.x=-SPEED*delta;#$AnimatedSprite2D.position=Vector2(22.333,0)
			elif state=='right':
				velocity.x=SPEED*delta;#$AnimatedSprite2D.position=Vector2(-22.333,0)
		"pinch":
			playerdamage_value=5
			animated_sprite_2d.play("pinch")
			animation_player.play("pinch")
			#var collision=move_and_collide(velocity*delta)
			#if collision:
				#velocity=velocity.bounce(collision.get_normal())

	move_and_slide()


func _on_normal_proj_hitbox_body_entered(_body):
	#if body.is_in_group("door"):#body.is_in_group("tilemap") or
		#queue_free()
	pass
