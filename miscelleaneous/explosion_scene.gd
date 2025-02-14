extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$death_effect.play()
var megaman_explosion=preload("res://assets/characters/player/megaman/megaman_explosions.tscn")
var explosion_spawner_timer=0;var new_particle;var new_particle2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	explosion_spawner_timer+=1
	
	if explosion_spawner_timer==1:
		megaman_explosion_instancing()


var limit=9;var new
func megaman_explosion_instancing(): #this produces the explosion effects for megaman
	#using two loops for two sets of explosions
	new_particle=megaman_explosion.instantiate()
	for i in limit:
		if i!=0:
			new=new_particle.duplicate()
			add_child(new)
			#print(i)
			new.direction=i
			
	for j in limit:
		if j!=0:
			new=new_particle.duplicate()
			add_child(new)
			new.direction=j
			new.SPEED=new.SPEED/2
#	if explosion_spawner_timer==1 or explosion_spawner_timer==30:
#
#		var m1=megaman_explosion.instantiate();var m2;var m3;var m4;var m5;var m6;var m7;var m8;
#		m1=megaman_explosion.instantiate();m2=megaman_explosion.instantiate();m3=megaman_explosion.instantiate();
#		m4=megaman_explosion.instantiate();m5=megaman_explosion.instantiate();m6=megaman_explosion.instantiate();
#		m7=megaman_explosion.instantiate();m8=megaman_explosion.instantiate();
#		m1.direction=1;m2.direction=2;m3.direction=3;m4.direction=4;
#		m5.direction=5;m6.direction=6;m7.direction=7;m8.direction=8
#
#		get_parent().add_child(m1);get_parent().add_child(m2);get_parent().add_child(m3);get_parent().add_child(m4);
#		get_parent().add_child(m5);get_parent().add_child(m6);get_parent().add_child(m7);get_parent().add_child(m8);
#		m1.global_position=global_position;m2.global_position=global_position;m3.global_position=global_position
#		m4.global_position=global_position;m5.global_position=global_position;m6.global_position=global_position
#		m7.global_position=global_position;m8.global_position=global_position
#		m1.z_index=2;m2.z_index=2;m3.z_index=2;m4.z_index=2;m5.z_index=2;m6.z_index=2;m7.z_index=2;m8.z_index=2;
#		#first instances get a speed of 4500;second instances;a speed of 4500/2;half the original speed
#		#gives it a explosion +acceleration effect
#		#reference:troperfive,Megaman 6 death effect
#		var speed_ref=5600
#		if explosion_spawner_timer==1:
#			m1.SPEED=speed_ref;m4.SPEED=speed_ref;m7.SPEED=speed_ref;
#			m2.SPEED=speed_ref;m5.SPEED=speed_ref;m8.SPEED=speed_ref;
#			m3.SPEED=speed_ref;m6.SPEED=speed_ref;
#		elif explosion_spawner_timer==30:
#			m1.SPEED=float(speed_ref/2.0);m4.SPEED=float(speed_ref/2.0);m7.SPEED=float(speed_ref/2.0);
#			m2.SPEED=float(speed_ref/2.0);m5.SPEED=float(speed_ref/2.0);m8.SPEED=float(speed_ref/2.0);
#			m3.SPEED=float(speed_ref/2.0);m6.SPEED=float(speed_ref/2.0);
