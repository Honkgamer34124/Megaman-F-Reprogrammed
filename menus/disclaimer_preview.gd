extends Node2D
@onready var animation_player = $AnimationPlayer_for_fadeout

@export var text_to_display={
	0:'This fangame is not originally mine. ',
	1:'This is a revival of Megaman F originally made by Mr Gambit.',
	2:'Some sprites that werent made by me and got modified are from his respective creators.',
	3:'Megaman is owned by Capcom',
	
	
	
}
var text_to_display_index=0
# Called when the node enters the scene tree for the first time.
func _ready():
	#$text.clear()
	animation_player.play("fadeout")
	#typewrite(text_to_display[text_to_display_index])

var fading_playing=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if text_to_display.has(text_to_display_index):
		$text.text=str(text_to_display[text_to_display_index])
	if Input.is_action_just_pressed('confirm'): #and fading_playing==false
		if text_to_display.has(text_to_display_index):
			text_to_display_index+=1
			animation_player.play("fadeout")
#			$text2.text=''
			#typewrite(text_to_display[text_to_display_index])
			fading_playing=true
			
	if text_to_display_index==4:
		get_tree().change_scene_to_file('res://menus/press_start_menu.tscn')

func _on_animation_player_for_fadeout_animation_finished(_anim_name):
	fading_playing=false

func typewrite(string):
	pass
	for i in string:
		$timer.start()
		$text2.add_text(i)
		
