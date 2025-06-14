extends Node2D
var content1_Array = Array()
@onready var rich_text_label = $RichTextLabel
var current_save_file_used = ""
var currentSelectionNo = 0
var confirmationNo = 0  #for chainging options in the confirmationDialog.
#should properly implement.


# Called when the node enters the scene tree for the first time.
func _ready():
	$saveMenuMusic.play()
	content1_Array.resize(5)
	current_save_file_used = GlobalScript.save_file1
	display_contents()
	$VBoxContainer/save_file1.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

	if Input.is_action_just_pressed("move_up"):
		currentSelectionNo -= 1
		grabFocusOnce()
	elif Input.is_action_just_pressed("move_down"):
		currentSelectionNo += 1
		grabFocusOnce()
	if currentSelectionNo < 0:
		currentSelectionNo = 4
	elif currentSelectionNo > 4:
		currentSelectionNo = 0
	if $ConfirmationDialog.visible:
		if Input.is_action_just_pressed("move_left"):
			confirmationNo = 0
			#$ConfirmationDialog.
		elif Input.is_action_just_pressed("move_right"):
			confirmationNo = 1


func display_contents():
	#rich_text_label.text="LIFE:"+str(content1_Array[0])+"\n ENERGY TANKS:"+str(content1_Array[1])+ "\n WEAPON TANKS:"+str(content1_Array[2])+"\n MEGA TANKS:"+str(content1_Array[3])+"\n BOLT NUMBER:"+str(content1_Array[4])+"\n Current_save_file_to_be_used:"+current_save_file_used+"\n Save file currently:"+GlobalScript.current_save_file
	if FileAccess.file_exists(current_save_file_used):
		var file = FileAccess.open(current_save_file_used, FileAccess.READ)
		if file != null:  #file.get_var()!=null
			var file_collectables = file.get_var()
			if file_collectables != null:
				content1_Array[0] = file_collectables.LIFE_NO
				content1_Array[1] = file_collectables.ENERGY_TANK_NO
				content1_Array[2] = file_collectables.WEAPON_TANK_NO
				content1_Array[3] = file_collectables.MEGA_TANK_NUMBER
				content1_Array[4] = file_collectables.BOLT_NUMBER
				rich_text_label.text = (
					"LIFE:"
					+ str(content1_Array[0])
					+ "\n ENERGY TANKS:"
					+ str(content1_Array[1])
					+ "\n WEAPON TANKS:"
					+ str(content1_Array[2])
					+ "\n MEGA TANKS:"
					+ str(content1_Array[3])
					+ "\n BOLT NUMBER:"
					+ str(content1_Array[4])
					+ "\n Current_save_file_to_be_used:"
					+ current_save_file_used
					+ "\n Save file currently:"
					+ GlobalScript.current_save_file
				)
	if not FileAccess.file_exists(current_save_file_used):
		var file_create = FileAccess.open(current_save_file_used, FileAccess.WRITE)
		var player_dict2 = {
			"LIFE_NO": 3,
			"ENERGY_TANK_NO": 0,
			"WEAPON_TANK_NO": 0,
			"MEGA_TANK_NUMBER": 0,
			"BOLT_NUMBER": 0,
			"ENERGY_BALANCER_NUMBER": 0
		}
		var weaponsRunTimeValues = {
			"1": false,
			"2": false,
			"3": false,
			"4": false,
			"5": false,
			"9": true,
			"10": true,
			#"RUSH_JET":false
		}
		if file_create != null:
			file_create.store_var(player_dict2)
			file_create.store_var(weaponsRunTimeValues)
			print(name, "->NO FILE-- creating new --", current_save_file_used, "-- file")
			file_create.close()


func grabFocusOnce():
	$hoverSound.play()
	match currentSelectionNo:
		0:
			$VBoxContainer/save_file1.grab_focus()
		1:
			$VBoxContainer/save_file2.grab_focus()
		2:
			$VBoxContainer/save_file3.grab_focus()
		3:
			$VBoxContainer/save_file4.grab_focus()
		4:
			$VBoxContainer/save_file5.grab_focus()


func play_sound_when_over_menu_button():
	$hoverSound.play()


func play_sound_when_making_an_option():
	$enterSound.play()


func _on_save_file_1_pressed():
	current_save_file_used = GlobalScript.save_file1
	display_contents()
	play_sound_when_making_an_option()
	$ConfirmationDialog.show()


func _on_save_file_2_pressed():
	current_save_file_used = GlobalScript.save_file2
	display_contents()
	play_sound_when_making_an_option()
	$ConfirmationDialog.show()


func _on_save_file_3_pressed():
	current_save_file_used = GlobalScript.save_file3
	display_contents()
	play_sound_when_making_an_option()
	$ConfirmationDialog.show()


func _on_save_file_4_pressed():
	current_save_file_used = GlobalScript.save_file4
	display_contents()
	play_sound_when_making_an_option()
	$ConfirmationDialog.show()


func _on_save_file_5_pressed():
	current_save_file_used = GlobalScript.save_file5
	display_contents()
	play_sound_when_making_an_option()
	$ConfirmationDialog.show()


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
	play_sound_when_making_an_option()


func _on_load_file_pressed():
	$ConfirmationDialog.show()
	play_sound_when_making_an_option()


func _on_confirmation_dialog_confirmed():
	pass  # Replace with function body.
	GlobalScript.current_save_file = current_save_file_used
	get_tree().change_scene_to_file("res://menus/robot_masters_menu.tscn")
	play_sound_when_making_an_option()


func _on_confirmation_dialog_canceled():
	$ConfirmationDialog.hide()
	play_sound_when_making_an_option()


func _on_save_file_1_mouse_entered():
	play_sound_when_over_menu_button()


func _on_save_file_2_mouse_entered():
	play_sound_when_over_menu_button()


func _on_save_file_3_mouse_entered():
	play_sound_when_over_menu_button()


func _on_save_file_4_mouse_entered():
	play_sound_when_over_menu_button()


func _on_save_file_5_mouse_entered():
	play_sound_when_over_menu_button()


func _on_load_file_mouse_entered():
	play_sound_when_over_menu_button()


func _on_back_to_menu_mouse_entered():
	play_sound_when_over_menu_button()


func _on_save_menu_music_finished():
	$saveMenuMusic.play()
