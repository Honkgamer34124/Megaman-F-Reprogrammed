extends State
@export var move_inch_timer: Timer
# @export var animation: AnimatedSprite2D
@export var dash_cooldown: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func Enter():
	move_inch_timer.start()
	var player = Player.player_character
	if player:
		var animation = player.animatedSprite2D
		if animation:
			animation.play("move_an_inch")
			pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	if not move_inch_timer.is_connected("timeout", TransitionToRunState):
		move_inch_timer.connect("timeout", TransitionToRunState)
	#print(move_inch_timer.one_shot)
	var player = Player.player_character
	if player and move_inch_timer:
		player.speed = player.moveAnInchSpeed
		if not player.is_on_floor():
			player.velocity += player.get_gravity() * delta
		var direction = Input.get_axis("move_left", "move_right")
		player.velocity.x = direction * player.moveAnInchSpeed * delta
		#if not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		#player.velocity.x = 0
		player.move_and_slide()

		if player.is_on_floor() and player.velocity.x == 0:
			transition.emit(self, "idlestate")
		if player.is_on_floor() and Input.is_action_just_pressed("jump"):
			transition.emit(self, "jumpstate")
		if Input.is_action_just_pressed("dash") and dash_cooldown.is_stopped():
			transition.emit(self, "dashstate")


func TransitionToRunState():
	#print("transition done")
	transition.emit(self, "runstate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
