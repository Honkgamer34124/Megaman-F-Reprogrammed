extends State
# @export var animation: AnimatedSprite2D
@export var dash_cooldown: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func Enter():
	var player = Player.playerCharacter
	if player:
		var animation = player.animatedSprite2D
		if animation:
			animation.play("run_normal")
			pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	var player = Player.playerCharacter
	if player:
		player.speed = player.normalSpeed
		if not player.is_on_floor():
			player.velocity += player.get_gravity() * delta
		var direction = Input.get_axis("move_left", "move_right")
		player.velocity.x = direction * player.normalSpeed * delta
		#if Input.is_action_pressed("move_left"):
		#player.velocity.x = -player.normalSpeed * delta
		#elif Input.is_action_pressed("move_right"):
		#player.velocity.x = player.normalSpeed * delta
		player.move_and_slide()

		if player.is_on_floor() and player.velocity.x == 0:
			transition.emit(self, "idlestate")
		if player.is_on_floor() and Input.is_action_just_pressed("jump"):
			transition.emit(self, "jumpstate")
		if Input.is_action_just_pressed("dash") and dash_cooldown.is_stopped():
			transition.emit(self, "dashstate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
