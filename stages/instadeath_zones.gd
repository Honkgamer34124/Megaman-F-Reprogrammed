extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	pass # Replace with function body.
	if body.is_in_group('player'):
		GlobalScript.health=0
