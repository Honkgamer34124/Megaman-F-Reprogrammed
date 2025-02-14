extends CharacterBody2D
@export var direction=1

@export var SPEED = 9500.0

func _ready():
	$anim.play("megaman_explosion")

func _physics_process(delta):
	match direction:
		1: #moves left
			velocity.x=SPEED*delta
		2: #moves right
			velocity.x=-SPEED*delta
		3: #moves up
			velocity.y=SPEED*delta
		4: #moves down
			velocity.y=-SPEED*delta
		5: #moves right,down
			velocity.x=SPEED*delta
			velocity.y=SPEED*delta
		6: #moves left,down
			velocity.x=-SPEED*delta
			velocity.y=SPEED*delta
		7: #moves right,up
			velocity.x=SPEED*delta
			velocity.y=-SPEED*delta
		8: #moves left,up
			velocity.x=-SPEED*delta
			velocity.y=-SPEED*delta
	move_and_slide()
