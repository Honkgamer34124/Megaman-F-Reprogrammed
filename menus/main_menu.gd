extends Node2D
@onready var switch_menu_timer = $switch_menu_timer

#@export var nodes_to_menu_option={
	#0:$Control/VBoxContainer/Button2,1:$Control/VBoxContainer/Button
#
#}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/VBoxContainer/start_game.connect('pressed',start_switch_timer)
	$Control/VBoxContainer/title_screen.connect('pressed',start_switch_timer)
	$Control/VBoxContainer/start_game.grab_focus()

var menu_option:int=0;var menu_ready_to_switch:bool=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	if menu_ready_to_switch and switch_menu_timer.time_left<=0:
		match menu_option:
			0:
				get_tree().change_scene_to_file('res://menus/save_file_menu.tscn')
			1:
				get_tree().change_scene_to_file("res://menus/press_start_menu.tscn")
		#2:
			#get_tree().change_scene_to_file("")
			3:
				get_tree().change_scene_to_file("res://menus/credits.tscn")
	if menu_option>4:
		menu_option=0
	elif menu_option<0:
		menu_option=4
	
	
	if menu_ready_to_switch==false:
		if Input.is_action_just_pressed("move_up"):
			menu_option-=1
			play_sound_when_over_menu_button()
			grabFocusOnce()
		elif Input.is_action_just_pressed("move_down"):
			menu_option+=1
			play_sound_when_over_menu_button()
			grabFocusOnce()
		#match menu_option:
			#0:
				#$Control/VBoxContainer/start_game.grab_focus()
			#1:
				#$Control/VBoxContainer/title_screen.grab_focus()
			#2:
				#$Control/VBoxContainer/options.grab_focus()
			#3:
				#$Control/VBoxContainer/credits.grab_focus()


func auto_grab_focus():
	pass
func grabFocusOnce():
	match menu_option:
		0:$Control/VBoxContainer/start_game.grab_focus()
		1:$Control/VBoxContainer/title_screen.grab_focus()
		2:$Control/VBoxContainer/options.grab_focus()
		3:$Control/VBoxContainer/credits.grab_focus()
		4:$Control/VBoxContainer/quit.grab_focus()
func start_switch_timer():
	switch_menu_timer.start()
	menu_ready_to_switch=true
	for i in $Control/VBoxContainer.get_children():
		if i is Button:
			i.disabled=true

func play_sound_when_over_menu_button():
	$hoverSound.play()
func play_sound_when_switching_menus():
	$enterSound.play()


func _on_button_2_pressed():
	#menu_option=0
	start_switch_timer()
	play_sound_when_switching_menus()

func _on_title_screen_pressed():
	#menu_option=1
	start_switch_timer()
	play_sound_when_switching_menus()

func _on_credits_pressed():
	#menu_option=3
	start_switch_timer()
	play_sound_when_switching_menus()



func _on_start_game_mouse_entered():
	$Control/VBoxContainer/start_game.grab_focus()
	play_sound_when_over_menu_button()

func _on_title_screen_mouse_entered():
	$Control/VBoxContainer/title_screen.grab_focus()
	play_sound_when_over_menu_button()

func _on_options_mouse_entered():
	$Control/VBoxContainer/options.grab_focus()
	play_sound_when_over_menu_button()

func _on_credits_mouse_entered():
	$Control/VBoxContainer/credits.grab_focus()
	play_sound_when_over_menu_button()






func _on_quit_pressed():
	get_tree().quit(0)
