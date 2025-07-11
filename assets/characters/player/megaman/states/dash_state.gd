extends State
@export var dash_timer: Timer
@export var dash_cooldown: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func Enter():
	if not dash_timer.is_connected("timeout", TransitionToWalkState):
		dash_timer.connect("timeout", TransitionToWalkState)
	dash_timer.start()
	var player = Player.player_character
	if player.animated_sprite_2d:
		player.animated_sprite_2d.play("dash")


func Exit():
	dash_cooldown.start()


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	#print(dash_timer.is_connected("timeout", TransitionToWalkState))
	print(dash_timer.is_stopped())
	var player = Player.player_character
	if player:
		#var direction = Input.get_axis("move_left", "move_right")
		if not player.is_on_floor():
			player.velocity.y += player.gravity * delta
		if Input.is_action_pressed("dash"):
			if player.animated_sprite_2d.flip_h == true:
				player.velocity.x = -1 * player.dash_speed * delta
			elif player.animated_sprite_2d.flip_h == false:
				player.velocity.x = 1 * player.dash_speed * delta
		elif Input.is_action_just_released("dash"):
			transition.emit(self, "runstate")


func TransitionToWalkState():
	#transition.emit()
	print("dash ")

	Input.action_release("dash")
	transition.emit(self, "runstate")
	print("dash btn released")
	#tran


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
