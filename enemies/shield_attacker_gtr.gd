extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var hasBeenOnWall: bool = false


func _ready() -> void:
	$AnimatedSprite2D.play("default")
	direction = "left"
	playerdamage_value = 4
	health = 5


var direction


func _physics_process(delta: float) -> void:
	spawn_collectables()
	match direction:
		"left":
			velocity.x = -18000 * delta
			$AnimatedSprite2D.flip_h = false
			$shield/L.set_deferred("disabled", false)
			$hitbox/L.set_deferred("disabled", false)
			$shield/R.set_deferred("disabled", true)
			$hitbox/R.set_deferred("disabled", true)
		"right":
			velocity.x = 18000 * delta
			$AnimatedSprite2D.flip_h = true
			$shield/L.set_deferred("disabled", true)
			$hitbox/L.set_deferred("disabled", true)
			$shield/R.set_deferred("disabled", false)
			$hitbox/R.set_deferred("disabled", false)
	if is_on_wall() and hasBeenOnWall == false:
		velocity.x = 0
		$AnimatedSprite2D.play("turn")
		hasBeenOnWall = true
	if not is_on_wall() and hasBeenOnWall == true:
		hasBeenOnWall = false
	move_and_slide()
	#print(direction)


func _on_animated_sprite_2d_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"turn":
			$AnimatedSprite2D.play("default")
			if direction == "left":
				direction = "right"
			elif direction == "right":  #velocity.x > 0:
				direction = "left"


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
