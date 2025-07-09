extends enemy
var player_in_zone = false
var jump_timing_timer = 0
@export var flea_color = "red"
const SPEED = 7000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var play_normal = 0


func _ready():
	health = 7
	playerdamage_value = 7
	match flea_color:
		"red":
			$anim.animation = "red_flea"
		"blue":
			$anim.animation = "blue_flea"


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#this checks if a player is in a flea's detection zone
	if player_in_zone == true:
		jump_timing_timer += 1
		if jump_timing_timer % 60 == 20 and is_on_floor():
			velocity.y = JUMP_VELOCITY

			#$Timer.start()
	elif player_in_zone == false:
		jump_timing_timer = 0
		#$Timer.stop()

	if not is_on_floor():
		$anim.frame = 1
		play_normal = 0
		if player_on_left == true:
			velocity.x = -SPEED * delta
		elif player_on_right == true:
			velocity.x = SPEED * delta
	elif is_on_floor():
		play_normal += 1  #uses a timer to play specific frames for effect(since,its not the player controlling it)
		if play_normal < 2:
			$anim.frame = 2
		if play_normal > 2:
			$anim.frame = 0
			#$Timer.stop()

	if is_on_floor():
		velocity.x = 0

	if player_in_body == true:
		if GlobalScript.playerhasbeenhit == false:
			#$stun.play()
			GlobalScript.health -= 3
			GlobalScript.playerhasbeenhit = true
	spawn_collectables()
	if health <= 0:
		pass
	move_and_slide()


var player_on_left = false
var player_on_right = false


func _on_detect_body_left_body_entered(body):
	if body.is_in_group("player"):
		player_in_zone = true
		player_on_left = true


func _on_detect_body_left_body_exited(body):
	if body.is_in_group("player"):
		player_in_zone = false
		player_on_left = false


func _on_detect_body_right_body_entered(body):
	if body.is_in_group("player"):
		player_in_zone = true
		player_on_right = true


func _on_detect_body_right_body_exited(body):
	if body.is_in_group("player"):
		player_in_zone = false
		player_on_right = false


var player_in_body = false


func _on_main_body_body_entered(body):
	if body.is_in_group("player"):
		player_in_body = true
		#body.stun()


func _on_main_body_body_exited(body):
	if body.is_in_group("player"):
		player_in_body = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func play_explosion():
	$anim.play("dead")
