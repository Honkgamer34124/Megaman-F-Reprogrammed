extends CharacterBody2D
@export_category('values')
@export var SPEED = 10000.0
@export var direction='left'
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.play("ready")
func _physics_process(delta):
	match direction:
		'left':
			animated_sprite_2d.flip_h=true
		'right':
			animated_sprite_2d.flip_h=false
	if animated_sprite_2d.animation=='active':
		match direction:
			'left':
				velocity.x=-SPEED*delta
			'right':
				velocity.x=SPEED*delta

	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation=='ready':
		animated_sprite_2d.play("active")


func _on_hitbox_body_entered(body):
	pass # Replace with function body.


func _on_hitbox_area_entered(area):
	if area.is_in_group('enemy'):
		area.get_parent().health-=4
		$hurt_enemy_effect.play()
