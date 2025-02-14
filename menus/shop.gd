extends Node2D
#@onready var bolt_number_display = $shop_main_menu/bolt_number_display
@onready var select_rect = $sprites_display/select_rect
@onready var menu_switch_sound_effect_node = $sounds_and_music/menu_switch
@onready var menu_select_sound_effect_node = $sounds_and_music/menu_select
@onready var menu_music_temporal = $sounds_and_music/menu_music_temporal
@onready var bolt_number_display = $shop_main_menu/bolt_number_display

var menu_select_index=1
@export var menu_select_node={}
@export var menu_bolts_price_index={
	1:20,2:30,3:40,4:80,5:300
}
@export var menu_display_prices_nodes={}
var can_select_menu_option:bool=true
var custom_menu_option_index=1
var menu_about_switch=false
var select_yes_no_btn:int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.load_tanks_values()
	if menu_music_temporal!=null:
		menu_music_temporal.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	## for debugging
	#GlobalScript.bolt_number=700
	#GlobalScript.print_fxn_custom(name,'GlobalScript:bolt no->',GlobalScript.bolt_number)
	#print('GlobalScript:bolt no->',GlobalScript.bolt_number)
	##for debugging
	var temp_bolt_number=str(GlobalScript.bolt_number)
	menu_select_index=clampi(menu_select_index,1,6)
	$shop_main_menu/bolt_number_display.text=temp_bolt_number.pad_zeros(5)
	#enables you to select the menu item you want
	for i in menu_select_node:
		if menu_select_node.has(i) and is_equal_approx(i,menu_select_index) and i<=5:
			select_rect.global_position=(get_node(menu_select_node[menu_select_index]).global_position+get_node(menu_select_node[menu_select_index]).offset)
			
			##debuggging
			#print(get_node(menu_select_node[menu_select_index]).offset,select_rect.global_position)
	for i in menu_bolts_price_index:
		if menu_display_prices_nodes.has(i):
			get_node(menu_display_prices_nodes[i]).text=str(menu_bolts_price_index[i])
	
	$text_display/life_number.text=str(GlobalScript.life)
	$text_display/e_tank_number.text=str(GlobalScript.energy_tank_number)
	$text_display/w_tank_number.text=str(GlobalScript.weapon_tank_number)
	$text_display/m_tank_number.text=str(GlobalScript.mega_tank_number)
	$text_display/energy_balancer_no.text=str(GlobalScript.energy_balancer_number)
	if not menu_about_switch:
		if can_select_menu_option:
			if Input.is_action_just_pressed("move_left"):
				menu_select_index-=1
				menu_switch_sound_effect_node.play()
			elif Input.is_action_just_pressed('move_right'):
				menu_select_index+=1
				menu_switch_sound_effect_node.play()
		if Input.is_action_just_pressed("shoot"):
			if can_select_menu_option==true:
				can_select_menu_option=false
			elif can_select_menu_option==false:
				can_select_menu_option=true
	if menu_select_index==6:
		$interfaces/main_menu_button.set_focus_mode(true)
		$interfaces/main_menu_button.grab_focus()
		$sprites_display/select_rect.visible=false
	elif menu_select_index!=6:
		$interfaces/main_menu_button.set_focus_mode(false)
		$sprites_display/select_rect.visible=true
	#if can_select_menu_option==false and :
		#match menu_select_index:
			#1:
				#pass
	
	if can_select_menu_option==false:
		$custom_pop_up_window.visible=true
		if Input.is_action_just_pressed("move_left"):
			select_yes_no_btn-=1
		elif Input.is_action_just_pressed("move_right"):
			select_yes_no_btn+=1
		select_yes_no_btn=clampi(select_yes_no_btn,0,1)
		match select_yes_no_btn:
			0:
				$custom_pop_up_window/buttons_container/yes.grab_focus()
			1:
				$custom_pop_up_window/buttons_container/no.grab_focus()
	elif can_select_menu_option:
		$custom_pop_up_window.visible=false
		select_yes_no_btn=0

func _on_yes_pressed():
	if GlobalScript.bolt_number>=menu_bolts_price_index[menu_select_index]:
		menu_select_sound_effect_node.play()
		match menu_select_index:
			1:
				GlobalScript.bolt_number-=menu_bolts_price_index[1]
				GlobalScript.life+=1
			2:
				GlobalScript.bolt_number-=menu_bolts_price_index.get(2)
				GlobalScript.energy_tank_number+=1
			3:
				GlobalScript.bolt_number-=menu_bolts_price_index[3]
				GlobalScript.weapon_tank_number+=1
			4:
				GlobalScript.bolt_number-=menu_bolts_price_index[4]
				GlobalScript.mega_tank_number+=1
			5:
				GlobalScript.bolt_number-=menu_bolts_price_index[5]
				GlobalScript.energy_balancer_number+=1
		GlobalScript.save_energy_weapon_tanks()
		can_select_menu_option=true
	else:
		can_select_menu_option=true

func _on_no_pressed():
	pass # Replace with function body.
	can_select_menu_option=true
	menu_select_sound_effect_node.play()


func _on_main_menu_button_pressed():
	menu_select_sound_effect_node.play()
	menu_about_switch=true
	#get_tree().change_scene_to_file('res://menus/robot_masters_menu.tscn')
	$timers/switch_to_menu_timer.start()


func _on_switch_to_menu_timer_timeout():
	pass # Replace with function body.
	get_tree().change_scene_to_file('res://menus/robot_masters_menu.tscn')


func _on_menu_music_temporal_finished():
	pass # Replace with function body.
	$sounds_and_music/menu_music_temporal.play()
