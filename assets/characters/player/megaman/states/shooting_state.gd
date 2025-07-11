extends State

@export var shooting_timer: Timer
var player


func _ready():
	player = Player.player_character
	shooting_timer = Timer.new()
	shooting_timer.one_shot = true
	shooting_timer.wait_time = 0.5  # duration of shooting animation
	add_child(shooting_timer)
	shooting_timer.connect("timeout", _on_shooting_finished)


func Enter():
	if player:
		#player.animatedSprite2D.play("stand_and_shoot")
		shooting_timer.start()
		# Instantiate projectile and play sound


func Exit():
	if shooting_timer.is_stopped() == false:
		shooting_timer.stop()


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	if Input.is_action_just_pressed("shoot"):
		_spawn_projectile()
		#print("yeah...")


func _on_shooting_finished():
	#emit_signal("transition", "attack_idle_state")
	pass  # transition to attack idle or no attack state


func _spawn_projectile():
	if player:
		print("spawn proj")
		var bullet = preload("res://weapons/bullet.tscn")
		var projectile = bullet.instantiate()
		get_parent().add_child(projectile)
		if player.animatedSprite2D.flip_h:
			projectile.direction = "left"
			projectile.global_position = (
				player.get_node("shoot_positions/shoot_ground/left").global_position
			)
		else:
			projectile.direction = "right"
			projectile.global_position = (
				player.get_node("shoot_positions/shoot_ground/right").global_position
			)
