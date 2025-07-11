extends State
# @export var animation: AnimatedSprite2D
@export var dashCooldown: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func Enter():
	var player = Player.player_character
	if player:
		var animation = player.animated_sprite_2d
		if animation:
			animation.play("idle")
			pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
		var player = Player.player_character
		if player:
			if not player.is_on_floor():
				player.velocity += player.get_gravity() * delta
			player.velocity.x = 0
			player.move_and_slide()
			var direction = Input.get_axis("move_left", "move_right")
			#if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			if direction != 0:
				if player.is_on_floor():
					transition.emit(self, "moveinchstate")
			else:
				pass
			if Input.is_action_just_pressed("jump") and player.is_on_floor():
				transition.emit(self, "jumpstate")
			if Input.is_action_just_pressed("dash") and dashCooldown.is_stopped():
				transition.emit(self, "dashstate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
