extends Area2D
##This checks if a player is in the deathzone or not.
var playerisindeathzone:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var _megaman=get_parent().get_node("megaman")
	if playerisindeathzone:
		if GlobalScript.playerhasbeenhit==false:
			GlobalScript.health=0

func _on_body_entered(body):
	if body.is_in_group("player"):
		playerisindeathzone=true
		#print("deathzones_template:playerin")
func _on_body_exited(body):
	if body.is_in_group("player"):
		playerisindeathzone=false
		#print("deathzones_template:playerout")


func _on_area_entered(area):
	if area.is_in_group('enemy'):
		area.get_parent().queue_free()
