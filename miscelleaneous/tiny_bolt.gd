extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_detect_player_area_2d_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		GlobalScript.bolt_number += 2
