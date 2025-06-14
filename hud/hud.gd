extends CanvasLayer
var screen_sizes: Dictionary = {
	"1920x1080": Vector2(1920, 1080),
	"768x720": Vector2(768, 720),
}
var select_menu_index = 1
@export var menu_sprites_arrangement_index = {}
#note: the healthbgs are 2 because i'm using them
#to support each other and not cause a bug
#a CanvasLayer bug
var color_original
var isGamePaused: bool = false
var didPLayerJustDie: bool = false
@onready var selection_square = $pause_screen_setup/menu_arrangements/select
var activelyShowBossHealth: bool = false:
	set(value):
		activelyShowBossHealth = value
	get:
		return activelyShowBossHealth


# Called when the node enters the scene tree for the first time.
func _ready():
	$ready_animation.play("ready")
	$fade_out_rectangle_effect.visible = false
	color_original = $pause_screen_setup/fade_out_rectangle.color
	$pause_screen_setup.visible = false
	$fadeInRect.visible = true
	var tween = create_tween()
	tween.tween_property($fadeInRect, "color", Color8(0, 0, 0, 0), 1)
	tween.connect("finished", fadeInFinished)
	add_option_temporal()


func fadeInFinished():
	$fadeInRect.visible = false


var weapon_energy_not_all_full = false
var array
@export var array_weapons_used: Array[Sprite2D]
var freezeTimeTrigger: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$debug_stats_display/animation_state_display.text = GlobalScript.animation_state_player
	$debug_stats_display/fps.text = str(Engine.get_frames_per_second())

	#if freezeTimeTrigger==true:
	#freezeTime()
	if (
		MegamanItems.weapon_number != 0
		and MegamanItems.weapon_color_dictionary_bodycolor1.has(MegamanItems.weapon_number)
	):
		MegamanItems.change_color_palette_progressbars_hud($weapon_energy_display/weapon_energy)
	#debug codes and display

	#Engine.get_frames_per_second()
	if MegamanItems.weapon_energy[6] == 27 and MegamanItems.weapon_energy[9] == 27:
		weapon_energy_not_all_full = false
	else:
		weapon_energy_not_all_full = true
	#code below checks if all the weapon energy are full or not
	#print('hud:weapon_not_full',weapon_energy_not_all_full)
	if GlobalScript.health <= 0 and didPLayerJustDie == false:
		didPLayerJustDie = true
		get_tree().paused = true
		$pauseGameOnDeathTimer.start()
	if isGamePaused == false:
		if Input.is_action_just_pressed("pause_game") and $pauseGameCDownTimer.time_left <= 0:
			isGamePaused = true
			get_tree().paused = true
			$pauseGameCDownTimer.start()
			Input.action_release("shoot")
			$pause_screen_setup.visible = true
			#get_tree().paused=true
			if GlobalScript.health > 0:
				$pause_menu.play()
	if (
		Input.is_action_just_pressed("pause_game")
		and isGamePaused == true
		and $pauseGameCDownTimer.time_left <= 0
	):
		$pauseGameCDownTimer.start()
		$pause_screen_setup.visible = false
		get_tree().paused = false
		isGamePaused = false
		if select_menu_index<=11 and select_menu_index>=0:
			select_menu_index = MegamanItems.weapon_number
		else:
			MegamanItems.weapon_number=0
			select_menu_index=0

	select_menu_index = clampi(select_menu_index, 0, 13)

	if isGamePaused == true:
		if MegamanItems.weapon_energy.has(select_menu_index): #and select_menu_index != 0:
			MegamanItems.weapon_number = select_menu_index
		elif select_menu_index == 0:
			MegamanItems.weapon_number = 0
	$health_backup3.texture = preload("res://assets/miscellaneous/progress_bars/bosses/mini_yellow_devil_bg.png"
	)
	$health_backup3.position.y = $health_backup2.position.y
	if activelyShowBossHealth == true:
		health_enemies()
	update_values()
	update_weapon_values()
	show_weapon_energy_on_hud()
	set_volume_of_music_on_pause()
	#display_available_weapons()

	for i in $"pause_screen_setup/menu_arrangements/weapon_display/icons+text".get_children():
		if i is Sprite2D:
			pass

	for i in array_weapons_used:
		#if MegamanItems.weapon_number<10:
		if (
			i != array_weapons_used[MegamanItems.weapon_number]
			and i != null
			and array_weapons_used[MegamanItems.weapon_number] != null
		):
			i.material.set_shader_parameter("greyscale_trigger", true)
	#if array_weapons_used.has(!MegamanItems.weapon_number):
	#sprite.set_shader_parameter("greyscale_trigger",true)
	#pass
	var sprite
	if MegamanItems.weapon_number < 10:
		sprite = array_weapons_used[MegamanItems.weapon_number]
	if sprite != null:  #and sprite!=-1:
		sprite.material.set_shader_parameter("greyscale_trigger", false)
		#print(sprite.name," ->",sprite.material.get_shader_parameter("greyscale_trigger"))
	#code below shows

	#print("hud:",ProjectSettings.get_setting("display/window/size/window_height_override"))
	if isGamePaused == true:
		$pause_screen_setup/menu_arrangements/megaman_idle_animated.play("feeling_lazy")
		#ProjectSettings.get_setting("display/window/size/viewport_width")
		##previous code for hotkeying changing window display
#		if Input.is_action_just_pressed("1"):
#			print('hud:resized one')
#			var size=screen_sizes.get(1)
#			DisplayServer.window_set_size(size)
#		elif Input.is_action_just_pressed("2"):
#			print('hud:resized two')
#			DisplayServer.window_set_size(screen_sizes.get(2))

		if !disabled_selection:
			if Input.is_action_just_pressed("move_up"):
				select_menu_index -= 1
				if GlobalScript.weaponsRunTimeValues.has(str(select_menu_index)):
					if GlobalScript.weaponsRunTimeValues[str(select_menu_index)] == false:
						select_menu_index -= 1
			elif Input.is_action_just_pressed("move_down"):
				select_menu_index += 1
				if GlobalScript.weaponsRunTimeValues.has(str(select_menu_index)):
					if GlobalScript.weaponsRunTimeValues[str(select_menu_index)] == false:
						select_menu_index += 1
			if select_menu_index >= 0 and select_menu_index <= 9:
				if Input.is_action_just_pressed("move_left"):
					select_menu_index -= 6
				elif Input.is_action_just_pressed("move_right"):
					select_menu_index += 6
		#if

		match select_menu_index:
			0:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/buster"
					. global_position
				)
			1:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/wp1"
					. global_position
				)
			2:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/wp2"
					. global_position
				)
			3:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/wp3"
					. global_position
				)
			4:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/wp4"
					. global_position
				)
			5:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/wp5"
					. global_position
				)
			6:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/magpulse"
					. global_position
				)
			7:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/wp7"
					. global_position
				)
			9:
				selection_square.global_position = (
					$"pause_screen_setup/menu_arrangements/weapon_display/icons+text/rush_coil"
					. global_position
				)
			11:
				$pause_screen_setup/menu_arrangements/select.global_position = (
					$pause_screen_setup/menu_arrangements/e_tank/energy_tank_icon.global_position
				)
				if (
					Input.is_action_just_pressed("shoot")
					and GlobalScript.health < GlobalScript.max_health
				):
					if GlobalScript.energy_tank_number > 0:
						GlobalScript.energy_tank_number -= 1
						disabled_selection = true
						var life_tween = create_tween()
						life_tween.tween_property(
							$pause_screen_setup/healthbar_pausescreen,
							"value",
							GlobalScript.max_health,
							.5
						)
						life_tween.connect("finished", life_tween_ended)
						#GlobalScript.health=GlobalScript.max_health
			12:
				$pause_screen_setup/menu_arrangements/select.global_position = (
					$pause_screen_setup/menu_arrangements/w_tank/weapon_tank_icon.global_position
				)
				if Input.is_action_just_pressed("shoot") and weapon_energy_not_all_full:
					if GlobalScript.weapon_tank_number > 0:
						disabled_selection = true
						GlobalScript.weapon_tank_number -= 1
						for i in (
							$pause_screen_setup/menu_arrangements/weapon_display/weapon_bars
							. get_children()
						):
							var weapon_tween = create_tween()
							weapon_tween.tween_property(i, "value", 27, .5)
							weapon_tween.connect("finished", weapon_tween_ended)
						#GlobalScript.health=GlobalScript.max_health
			13:
				$pause_screen_setup/menu_arrangements/select.global_position = (
					$pause_screen_setup/menu_arrangements/m_tank/mega_tank_icon.global_position
				)
				if (
					Input.is_action_just_pressed("shoot")
					and (
						weapon_energy_not_all_full or GlobalScript.health < GlobalScript.max_health
					)
				):
					if GlobalScript.mega_tank_number > 0:
						disabled_selection = true
						GlobalScript.mega_tank_number -= 1

##weapon energy tween
						for i in (
							$pause_screen_setup/menu_arrangements/weapon_display/weapon_bars
							. get_children()
						):
							var weapon_tween = create_tween()
							weapon_tween.tween_property(i, "value", 27, .5)
							weapon_tween.connect("finished", weapon_tween_ended)
##life energy tween
						var life_tween = create_tween()
						life_tween.tween_property(
							$pause_screen_setup/healthbar_pausescreen,
							"value",
							GlobalScript.max_health,
							.5
						)
						life_tween.connect("finished", life_tween_ended)
	else:
		$pause_screen_setup/menu_arrangements/megaman_idle_animated.pause()


var color_current
var darkened
var disabled_selection = false


func fade_effect():
	$fade_out_rectangle_effect.visible = true
	color_current = $fade_out_rectangle_effect.color
	#print(color_current)
	darkened = Color(color_current).darkened(0.1)
	$fade_out_rectangle_effect.color = Color(darkened)
	#if darkened==Color


func add_option_temporal():
	for value in screen_sizes:
		options_button.add_item(value)


@onready var options_button = $pause_screen_setup/options/resolution_dropdown

var set_volume_once: bool = false
var previous_bgm_volume_db: float


func set_volume_of_music_on_pause():
	for i in get_tree().current_scene.get_children():
		if i.is_class("AudioStreamPlayer") and i.is_in_group("bgm"):
			if isGamePaused == true and not set_volume_once:
				## takes current volume,reduces current volume on the bgm
				previous_bgm_volume_db = i.volume_db
				i.volume_db = i.volume_db - 10
				set_volume_once = true
			elif isGamePaused == false and set_volume_once == true:
				i.volume_db = previous_bgm_volume_db
				set_volume_once = false
			if GlobalScript.health <= 0:
				i.stop()
	## debugging for checking the bgm and its volume in db
	#print('hud:set_volume_of_music_on_pause():bgm.name: ',i.name,',volume_db:',i.volume_db)


func freezeTime():
	self.get_tree().paused = true


func unfreezeTime():
	#self.set_physics_process(true)
	#self.set_process(true)
	self.get_tree().paused = false


func doFancyBossHealthBarFill():
	var tween = create_tween()
	tween.tween_property($boss_healthbar, "value", 27, 1).from(0)
	tween.connect("finished", unfreezeTime)
	activelyShowBossHealth = true
	#set_activelyShowBossHealth()


func _on_resolution_dropdown_item_selected(index):
	var selected_size = screen_sizes.get(options_button.get_item_text(index))
	DisplayServer.window_set_size(selected_size)
	if selected_size == screen_sizes.get("1920x1080"):
		DisplayServer.window_set_position(Vector2i(10, 30))
	elif selected_size == screen_sizes.get("768x720"):
		DisplayServer.window_set_position(Vector2i(500, 100))


#func _process():
#	#DisplayServer.window_set_size(Vector2(1920,1080))
#	health_enemies()
#func revert():
#	get_tree().paused=false
#	$pause_screen_setup/fade_out_rectangle.visible=false
#	$pause_screen_setup/fade_out_rectangle.color=color_original
var index_enemy_health = 1


func health_enemies():

	if index_enemy_health == 1:
		
		$boss_healthbar.texture_progress = preload(
			"res://assets/miscellaneous/progress_bars/bosses/mini_yellow_devil_healthbar.png"
		)
		
		$boss_healthbar.set_global_position(
			$health_backup3/miniyellowdevil.global_position - Vector2(0, 4)
		)
		$boss_healthbar.value = GlobalScript.boss_health[1]
		GlobalScript.boss_health[1] -= 1


func life_tween_ended():
	GlobalScript.health = GlobalScript.max_health
	disabled_selection = false


func weapon_tween_ended():
	disabled_selection = false
	for i in MegamanItems.weapon_energy:
		if MegamanItems.weapon_energy.has(i):
			MegamanItems.weapon_energy[i] = 27
	GlobalScript.save_energy_weapon_tanks()


#@export var nodes_to_weapon_no={
#0:null,1:null,2:null,3:null,4:null,5:null,6:null,7:null,8:null,9:null,10:null
#}
@export var bars_to_weapon_no = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
	10: null
}
#func display_available_weapons():
##print('working')
#for i in nodes_to_weapon_no:
#if GlobalScript.weaponsRunTimeValues.has(str(i)) and GlobalScript.weaponsRunTimeValues[str(i)]==false:
#var node=get_node(nodes_to_weapon_no[i])
#var node2=get_node(bars_to_weapon_no[i])
#if (node!=null and node2!=null):
#node.visible=false;node2.visible=false
##print(i)


func update_values():
	$healthbar.value = GlobalScript.health
	$healthbar.max_value = GlobalScript.max_health
	$lives/no_of_lives.text = str(GlobalScript.life)
	#pause screen live readings
	$pause_screen_setup/healthbar_pausescreen.value = GlobalScript.health
	$pause_screen_setup/healthbar_pausescreen.max_value = GlobalScript.max_health
	$pause_screen_setup/lives_left.text = str(GlobalScript.life)
	var bolt_no: String = str(GlobalScript.bolt_number)
	$pause_screen_setup/menu_arrangements/bolts/bolt_number.text = bolt_no.pad_zeros(5)
	var energy_tank_no_temporal_value = str(GlobalScript.energy_tank_number)
	$pause_screen_setup/menu_arrangements/e_tank/e_tank_no.text = (
		energy_tank_no_temporal_value.pad_zeros(2)
	)
	var weapon_tank_no_temporal_value = str(GlobalScript.weapon_tank_number)
	$pause_screen_setup/menu_arrangements/w_tank/w_tank_no.text = (
		weapon_tank_no_temporal_value.pad_zeros(2)
	)
	var mega_tank_temporal_value = str(GlobalScript.mega_tank_number)
	$pause_screen_setup/menu_arrangements/m_tank/m_tank_no.text = (
		str(mega_tank_temporal_value).pad_zeros(2)
	)


func show_weapon_energy_on_hud():
	if MegamanItems.weapon_number == 0:
		$weapon_energy_display.visible = false
	elif MegamanItems.weapon_number != 0:
		$weapon_energy_display.visible = true

	if MegamanItems.weapon_energy.has(MegamanItems.weapon_number):
		$weapon_energy_display/weapon_energy.value = MegamanItems.weapon_energy[
			MegamanItems.weapon_number
		]
		$weapon_energy_display/weapon_energy_text.text = (
			str(MegamanItems.weapon_energy[MegamanItems.weapon_number]).pad_zeros(2)
		)
		#$weapon_energy_display/weapon_energy_text.text=
	if MegamanItems.weapon_number >= 1 and MegamanItems.weapon_number <= 10:
		$weapon_energy_display/weapon_icon2.frame = MegamanItems.weapon_number


#region showing switches b/n weapons using an icon and showing the value and text of the weapon
#match MegamanItems.weapon_number:
#6:
#$weapon_energy_display/weapon_icon2.frame=0
##$weapon_energy_display/weapon_energy.value=MegamanItems.weapon_energy[5]
##$weapon_energy_display/weapon_energy_text.text=str(MegamanItems.weapon_energy[5])
#9:
#$weapon_energy_display/weapon_icon2.frame=1
##$weapon_energy_display/weapon_energy.value=MegamanItems.weapon_energy[9]
#10:
#$weapon_energy_display/weapon_icon2.frame=2
##$weapon_energy_display/weapon_energy.value=MegamanItems.weapon_energy[10]
#endregion


func update_weapon_values():
	$pause_screen_setup/menu_arrangements/weapon_display/weapon_bars/m_pulse.value = (
		MegamanItems.weapon_energy[6]
	)
	$pause_screen_setup/menu_arrangements/weapon_display/weapon_bars/r_coil.value = (
		MegamanItems.weapon_energy[9]
	)


func _on_intro_stage_pressed():
	#GlobalScript.robot_master_option=3
	get_tree().paused = false
	#get_tree().change_scene_to_file('res://stages/intro_stage.tscn')
	GlobalScript.custom_change_scene_function("res://stages/intro_stage.tscn")


func _on_test_stage_1_pressed():
	#GlobalScript.robot_master_option=5
	get_tree().paused = false
	GlobalScript.custom_change_scene_function("res://stages/test_stage_1.tscn")
	#get_tree().change_scene_to_file('res://stages/test_stage_1.tscn')


func _on_test_stage_2_free_fall_pressed():
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://stages/test_stage_fall_limits.tscn")
	GlobalScript.custom_change_scene_function("res://stages/test_stage_fall_limits.tscn")


func _on_acidman_stage_button_pressed():
	pass  # Replace with function body.
	get_tree().paused = false
	GlobalScript.custom_change_scene_function("res://stages/8_main_stages/acidman_stage.tscn")
	#get_tree().change_scene_to_file('res://stages/8_main_stages/acidman_stage.tscn')


func _on_beginning_menu_pressed():
	get_tree().paused = false
	GlobalScript.custom_change_scene_function("res://menus/press_start_menu.tscn")
	#get_tree().change_scene_to_file('res://menus/press_start_menu.tscn')


func _on_robot_masters_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/robot_masters_menu.tscn")


func _on_disclaimer_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/disclaimer_preview.tscn")


func _on_ready_animation_animation_finished():
	$ready_animation.visible = false


func exitingOptions():
	disabled_selection = false
	print("exiting optionsMenu")
	print(name, ": disabled selection 4 options menu:", disabled_selection)


var optionsMenu


func _on_options_menu_btn_pressed():
	optionsMenu = preload("res://hud/hud_option_menu.tscn").instantiate()
	get_parent().add_child(optionsMenu)
	if optionsMenu and optionsMenu.is_inside_tree():
		disabled_selection = true
		optionsMenu.connect("tree_exiting", exitingOptions)
		print(name, ": disabled selection 4 options menu:", disabled_selection)


func _on_pause_game_on_death_timer_timeout():
	get_tree().paused = false


func _on_freeze_game_timer_timeout() -> void:
	unfreezeTime()
