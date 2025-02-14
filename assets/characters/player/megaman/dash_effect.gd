extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$animated_sprite2d.play("dash_effect")
	$animated_sprite2d.z_index=-1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $animated_sprite2d.frame==3:
		queue_free()
