extends Node2D
@export var option = 1
@onready var cursor = $RobotMastersMenuSelectCursor
@onready var cursor_temp = $cursor
@onready var menu_music = $sound_effects_music/menu_music
@onready var robot_master_select = $sound_effects_music/robot_master_select
@onready var menu_confirm = $sound_effects_music/menu_confirm
var start_timer = false
var timer = 0
var menu_ready_to_be_displayed: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.robot_master_option = 5

	cursor_temp.play("select")
	menu_music.play()
	$all_select_sprites/AnimatedSprite2D.play("select")
	$"MmfRobotMenuPart1-export".global_position.y = 900
	$"MmfRobotMenuPart2-export".global_position.y = -900
	$"MmfRobotMenuPart3-export".global_position.y = 900
	var start_trans_tween = create_tween()
	start_trans_tween.tween_property($"MmfRobotMenuPart1-export", "position", Vector2(0, 0), 1)
	start_trans_tween.connect("finished", show_menu_now)
	var start_trans_tween2 = create_tween()
	start_trans_tween2.tween_property($"MmfRobotMenuPart2-export", "position", Vector2(270, 0), 1)
	var start_trans_tween3 = create_tween()
	start_trans_tween3.tween_property($"MmfRobotMenuPart3-export", "position", Vector2(507, 0), 1)
	#state of disappeared menu
	$cursor.visible = false
	$all_robot_masters_names.visible = false
	$all_robot_masters_portraits.visible = false
	$all_select_sprites.visible = false
	$megaman_select.visible = false
	$menu_buttons.visible = false
	$press_start.visible = false


var selected_menu = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if timer>0:
	#print(name,"-> Timer:",timer)
	#print('robot masster menu;has any node with group:disappear:',get_tree().has_group("disappear"))
#	if get_tree().has_group("disappear"):
#		pass
	$all_select_sprites/AnimatedSprite2D.frame = cursor_temp.frame
	if menu_ready_to_be_displayed == true:  #if the menu is ready:
		if start_timer == true:
			timer += 1 * delta

			#print(name,"-> timer:",timer)
			if timer >= 1:
				GlobalScript.restarted_stage = false
				get_tree().paused = false
				GlobalScript.load_tanks_values()
				match GlobalScript.robot_master_option:
					1:
						if GlobalScript.life <= -1:
							GlobalScript.life = 3

						#if GlobalScript.weaponsRunTimeValues["1"]==true:
						#get_tree().change_scene_to_file("res://stages/test_stuff/partlcle_test_scene.tscn")
						GlobalScript.custom_change_scene_function(
							"res://stages/8_main_stages/acidman_stage.tscn"
						)
					3:
#						print("loading screen: loaded intro scene")
						if GlobalScript.life <= -1:
							GlobalScript.life = 3
						GlobalScript.custom_change_scene_function("res://stages/intro_stage.tscn")
						#get_tree().change_scene_to_file("res://stages/intro_stage.tscn")
					5:
						if GlobalScript.life <= -1:
							GlobalScript.life = 3
						GlobalScript.custom_change_scene_function("res://stages/test_stage_1.tscn")
					10:
						GlobalScript.custom_change_scene_function("res://menus/save_file_menu.tscn")
					11:
						GlobalScript.custom_change_scene_function("res://menus/main_menu.tscn")
					12:
						GlobalScript.custom_change_scene_function("res://menus/shop.tscn")

		if !selected_menu:
			if Input.is_action_just_pressed("confirm"):  #code for selecting a stage/any menu using enter button
				selected_menu = true
				menu_confirm.play()
				start_timer = true

			if Input.is_action_just_pressed("move_left"):
				GlobalScript.robot_master_option -= 1
				robot_master_select.play()
			elif Input.is_action_just_pressed("move_right"):
				GlobalScript.robot_master_option += 1
				robot_master_select.play()
			elif Input.is_action_just_pressed("move_up"):
				GlobalScript.robot_master_option -= 3
				robot_master_select.play()
			elif Input.is_action_just_pressed("move_down"):
				GlobalScript.robot_master_option += 3
				robot_master_select.play()
			if Input.is_action_just_pressed("confirm"):
				if GlobalScript.robot_master_option != 5:
					menu_confirm.play()
				else:
					pass

	if GlobalScript.robot_master_option < 1:
		GlobalScript.robot_master_option = 9
	elif GlobalScript.robot_master_option > 12:
		GlobalScript.robot_master_option = 1

	$megaman_select.frame = GlobalScript.robot_master_option - 1

	match GlobalScript.robot_master_option:
		1:
			cursor_temp.global_position = $all_cursors_pointers/acid_man.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = (
				$all_robot_masters_portraits/acid_man.global_position
			)
		2:
			cursor_temp.global_position = $all_cursors_pointers/fusion_man.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = (
				$all_robot_masters_portraits/fusion_man.global_position
			)
		3:
			#print("balckhole man selected")
			cursor_temp.global_position = $all_cursors_pointers/blackhole_man.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = (
				$all_robot_masters_portraits/blackhole_man.global_position
			)
		4:
			#print("devilman selected")
			cursor_temp.global_position = $all_cursors_pointers/devil_man.global_position
		5:
			cursor_temp.global_position = $all_cursors_pointers/megaman.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = $megaman_select.global_position
		6:
			cursor_temp.global_position = $all_cursors_pointers/fault_man.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = (
				$all_robot_masters_portraits/fault_man.global_position
			)  #+Vector2(1,0)
		7:
			cursor_temp.global_position = $all_cursors_pointers/smoke_man.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = (
				$all_robot_masters_portraits/smoke_man.global_position
			)
		8:
			cursor_temp.global_position = $all_cursors_pointers/magpulse_man.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = (
				$all_robot_masters_portraits/magpulse_man.global_position
			)
		9:
			cursor_temp.global_position = $all_cursors_pointers/chaos_man.global_position
			$all_select_sprites/AnimatedSprite2D.global_position = (
				$all_robot_masters_portraits/chaos_man.global_position
			)

	if menu_ready_to_be_displayed:
		if GlobalScript.robot_master_option >= 10:
			cursor_temp.visible = false
			$all_select_sprites/AnimatedSprite2D.visible = false
			$menu_buttons/main_menu.focus_mode = true
			$menu_buttons/shop.focus_mode = true
			$megaman_select.frame = 4
		else:
			cursor_temp.visible = true
			$all_select_sprites/AnimatedSprite2D.visible = true
			$menu_buttons/main_menu.focus_mode = false
			$menu_buttons/shop.focus_mode = false

	match GlobalScript.robot_master_option:
		10:
			$menu_buttons/save_file.grab_focus()
		11:  #cursor_temp.visible=false
			$menu_buttons/main_menu.grab_focus()
		12:  #cursor_temp.visible=false
			$menu_buttons/shop.grab_focus()


func _on_menu_music_finished():
	menu_music.play(01.406)


func show_menu_now():
	menu_ready_to_be_displayed = true
	$cursor.visible = true
	$all_robot_masters_names.visible = true
	$all_robot_masters_portraits.visible = true
	$all_select_sprites.visible = true
	$megaman_select.visible = true
	$menu_buttons.visible = true
	$press_start.visible = true
	$MenuAnimationPlayer.play("menuAnimation1")


func _on_shop_pressed():
	pass
	GlobalScript.robot_master_option = 12


func _on_switch_menu_timeout():
	pass  # Replace with function body.
	get_tree().change_scene_to_file("res://menus/shop.tscn")


func switch_menus():
	#selected_menu=true
	#$timers/switch_menu.start()
	start_timer = true
	#menu_confirm.play()
	#$menu_buttons/shop.disabled=true
	for i in $menu_buttons.get_children():
		if i is Button:
			i.disabled = true


func _on_main_menu_pressed():
	selected_menu = true
	$timers/switch_menu.start()
	menu_confirm.play()
	#$menu_buttons/shop.disabled=true
	for i in $menu_buttons.get_children():
		if i is Button:
			i.disabled = true
	GlobalScript.robot_master_option = 11
	#print(name,'-> main_menu selected')


func _on_button_pressed():
	GlobalScript.robot_master_option = 10
	selected_menu = true
	$timers/switch_menu.start()
	menu_confirm.play()
