extends State
# @export var animation: AnimatedSprite2D
var happenOnce: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func Enter():
	var player = Player.playerCharacter
	if player:
		pass
	var animation = player.animatedSprite2D
	if animation:
		animation.play("jump")


func Exit():
	happenOnce = false


func Update(_delta: float):
	pass


func Physics_Update(delta: float):
	var player = Player.playerCharacter
	if player:
		if happenOnce == false:
			player.velocity.y = -16 * 4 * 600 * delta
			happenOnce = true
			if player.velocity.y < 0:
				if Input.is_action_just_released("jump"):
					player.velocity.y = 0
		if not player.is_on_floor():
			#print(player.get_gravity())
			player.velocity.y += 2500 * delta
		var direction = Input.get_axis("move_left", "move_right")
		#if Input.is_action_pressed("move_left"):
		#player.velocity.x = -player.normalSpeed * delta
		#elif Input.is_action_pressed("move_right"):
		player.velocity.x = direction * player.normalSpeed * delta
		player.move_and_slide()

		if player.is_on_floor():
			transition.emit(self, "runstate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
