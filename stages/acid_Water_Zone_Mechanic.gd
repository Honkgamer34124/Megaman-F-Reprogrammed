extends Area2D
var water_effect = preload("res://miscelleaneous/water_effect.tscn")
var state = "up"


# Called when the node enters the scene tree for the first time.
func _ready():
	$riseWaterTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(delta: float) -> void:
	if $riseWaterTimer/riseWaterUpDownTimer.is_stopped() == false:
		match state:
			"up":
				position.y += 100 * delta
			"down":
				position.y -= 100 * delta
	elif $riseWaterTimer/riseWaterUpDownTimer.is_stopped() == true:
		pass


var number = 1


func _on_animated_sprite_2d_animation_finished():
	pass


func _on_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		var body = area.get_parent()
		body.gravity = body.gravity - 2000
		body.animatedSprite2D.set_speed_scale(.8)
		var new_water_effect = water_effect.instantiate()
		self.add_child(new_water_effect)
#		if get_node('water_effect')!=null:
#			self.add_child(water_effect)
		#var new_animated_sprite=$AnimatedSprite2D.new()
		new_water_effect.global_position = body.global_position + Vector2(0, 20)
		$hurtPlayerTimer.start()


func _on_area_exited(area):
	pass  # Replace with function body.
	if area.is_in_group("player_camera_transition_hitbox"):
		var body = area.get_parent()
		body.gravity = 3000
		body.animatedSprite2D.set_speed_scale(1)
		#new_water_effect=water_effect.duplicate()
		var new_water_effect = water_effect.instantiate()
		self.add_child(new_water_effect)
#		if get_node('water_effect')!=null:
#			self.add_child(water_effect)
		#var new_animated_sprite=$AnimatedSprite2D.new()
		new_water_effect.global_position = body.global_position + Vector2(0, 65)
		#new_water_effect.play("water_enter_in")
		$hurtPlayerTimer.stop()


func _on_rise_water_timer_timeout() -> void:
	$riseWaterTimer/riseWaterUpDownTimer.start()


func _on_rise_water_up_down_timer_timeout() -> void:
	if state == "up":
		state = "down"
	elif state == "down":
		state = "up"


func _on_hurt_player_timer_timeout() -> void:
	GlobalScript.health -= 4
