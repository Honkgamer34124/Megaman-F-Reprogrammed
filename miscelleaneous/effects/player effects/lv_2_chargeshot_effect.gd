extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play("animation")

var direction_to_face:String
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match direction_to_face:
		'left': flip_h=true
		'right':flip_h=false
func _on_animation_finished():
	queue_free()
