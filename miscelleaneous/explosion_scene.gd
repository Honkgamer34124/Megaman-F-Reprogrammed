extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$death_effect.play()
	await  get_tree().process_frame
	megaman_explosion_instancing()
	await  get_tree().create_timer(5,false).timeout
	queue_free()
var megaman_explosion=preload("res://assets/characters/player/megaman/megaman_explosions.tscn")
var explosion_spawner_timer=0;var new_particle;var new_particle2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#explosion_spawner_timer+=1
	pass
	#if explosion_spawner_timer==1:



var limit=9;var new
#this produces the explosion effects for megaman using two loops for two sets of explosions
func megaman_explosion_instancing():
	new_particle=megaman_explosion.instantiate()
	for explosion_group_1 in limit:
		if explosion_group_1!=0:
			new=new_particle.duplicate()
			add_child(new)
			new.direction=explosion_group_1
			
	for explosion_group_2 in limit:
		if explosion_group_2!=0:
			new=new_particle.duplicate()
			add_child(new)
			new.direction=explosion_group_2
			new.SPEED=new.SPEED/2
