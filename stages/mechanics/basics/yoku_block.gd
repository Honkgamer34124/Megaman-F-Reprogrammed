extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var sound_effect_play_once:bool=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible==false:
		print(name,' : [yoku_block]:not_visible')
		sound_effect_play_once=false
		$CollisionShape2D.disabled=true
		$AnimatedSprite2D.stop()
		$yoku_sound_new.stop()
	elif self.visible==true:
		if !sound_effect_play_once:
			$yoku_sound_new.play();
			sound_effect_play_once=true
		$CollisionShape2D.disabled=false
	#print(sound_effect_play_once)
#		if $AnimatedSprite2D.animation!='appears':
#			$AnimatedSprite2D.play("appears")
	#print(name+': collisionshape2d disabled:'+ str($CollisionShape2D.disabled))


func _on_visibility_changed():
	if is_inside_tree():
		$AnimatedSprite2D.play("appears")
		#$yoku_sound_new.play();
		#print(name+': ..'+':visibility chnaged')


func _on_visible_on_screen_enabler_2d_screen_entered():
	#sound_effect_play_once=false
	pass


func _on_hidden():
	pass # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited():
	#sound_effect_play_once=
	pass
