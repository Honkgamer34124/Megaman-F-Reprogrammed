extends enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready() -> void:
	playerdamage_value = 4
	health = 3
	$AnimatedSprite2D.play("default")


func _physics_process(delta: float) -> void:
	spawn_collectables()
	var distanceX = GlobalScript.player_position_x - global_position.x
	var distanceY = GlobalScript.player_position_y - global_position.y
	var newPostionX = move_toward(global_position.x, GlobalScript.player_position_x, 42 * delta)
	var newPostionY = move_toward(global_position.y, GlobalScript.player_position_y, 42 * delta)
	global_position = Vector2(newPostionX, newPostionY)
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
