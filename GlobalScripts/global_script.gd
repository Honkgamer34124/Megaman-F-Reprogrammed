extends Node
var health:int=27;var max_health:int=27
var life:int=3
var bolt_number:int=0
var energy_tank_number:int=0;var max_energy_tank_number:int=9;
var weapon_tank_number:int=0;var max_weapon_tank_number:int=5;
var mega_tank_number:int=0;var max_mega_tank_number:int=1;
var energy_balancer_number:int=0;
var item_randomizer:int=1
var playerhasbeenhit:bool=false;var playerHitCooldownTimer=0
var player_position_x:int=0;var player_position_y:int=0 #is used to find the player's current position
var global_timer=0 #plan is to use this to time events in each frame
var robot_master_option:int=0 #used to select robot masters
var lemonsOnScreen:int=0

var restarted_stage=false;var loaded_stage=false
var save_path="res://save_files/save.megaman"
var save_file1='res://save_files/save_file1.megaman'
var save_file2='res://save_files/save_file2.megaman'
var save_file3="res://save_files/save_file3.megaman"
var save_file4="res://save_files/save_file4.megaman"
var save_file5="res://save_files/save_file5.megaman"
var current_save_file:String

var current_scene_path:String
var previous_scene:String
var next_scene:String
var time
var soundEffectVolumeDB:float=0.0
var BGMVolumeDB:float=0.0

var transitioning:bool=false
var weaponsRunTimeValues={
	"1":false,"2":false,"3":false,"4":false,
	"5":false,"6":true,"9":false,"10":false
}
var weapons_collected_save_values={
	"1":false,"2":false,"3":false,"4":false,
	"5":false,"6":false,"9":true,"10":true,
	#"RUSH_JET":false
}
var optionsData={
	"soundsVolume"={
		"BGM":0,
		"VFX":0
	}
}
#key:
#MAGPULSE->5
#RUSH_COIL->9
#RUSH_JET->10

#var weapon_selected_number=1
#var player_on_floor=true
var boss_health={
	1:26,
}
var animation_state_player=''
var testFolder="res://save2"
# Called when the node enters the scene tree for the first time.
func _ready():
	#save_data2()
	current_save_file=save_file1
	pass # Replace with function body.
	var filenull
	filenull=FileAccess.open(testFolder,FileAccess.WRITE)
	#var directory=DirAccess.open("res://")
	#print(directory)
	#print("Diretory exists:",directory.dir_exists_absolute("res://save2"))
	#if directory.dir_exists_absolute("res://save2")==false:
		#
		#directory.make_dir_absolute("res://save2")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##debug section
	#print_fxn_custom(name,"weaponsRunTimeValues[5]",weaponsRunTimeValues["5"])#weaponsRunTimeValues["MAGPULSE"]
	#GlobalScript.weaponsRunTimeValues["6"]=false

	##
	#if health<0:
		#health=0
	#elif health>max_health:
		#health=max_health
	health=clampi(health,0,max_health)
	life=clampi(life,-1,9)#-1 so that if someone loses all his/her life,he/ she can get 3 lives to begin a stage.
	energy_tank_number=clampi(energy_tank_number,0,max_energy_tank_number)
	weapon_tank_number=clampi(weapon_tank_number,0,max_weapon_tank_number)
	mega_tank_number=clampi(mega_tank_number,0,max_mega_tank_number)
	lemonsOnScreen=clampi(lemonsOnScreen,0,3)
	energy_balancer_number=clampi(energy_balancer_number,0,1)
	if playerhasbeenhit==true:#checks and increases timer if player has been hit
		playerHitCooldownTimer+=1*delta
	if playerHitCooldownTimer>=1:#resets timer and hit cooldown upon timeup(t=1 second)
		playerhasbeenhit=false
		playerHitCooldownTimer=0
	#print_fxn_custom(name,"MegamanItems.weapon_number",MegamanItems.weapon_number)
	
	
	#if optionsData:
		#var q=JSON.stringify(optionsData)
		#print("JSON:",q)



func print_fxn_custom(name_of_node,name_of_value_to_used,value_to_be_displayed):
	print(name_of_node,":",str(name_of_value_to_used),":",value_to_be_displayed)
func restart_global_timer():
	global_timer=0

func custom_change_scene_function(newScenePath:String):
	current_scene_path=get_tree().current_scene.get_scene_file_path() 
	next_scene=newScenePath
	if next_scene != current_scene_path:
		restarted_stage=false
	if life<=0:
		life=3
	save_energy_weapon_tanks()
	get_tree().change_scene_to_file(newScenePath)
	
	print(name,":current->next Scenes::",current_scene_path,"\n",next_scene)


func load_player_checkpoint_positions():
	#code for loading data
	var file= FileAccess.open(save_path,FileAccess.READ)
	if FileAccess.file_exists(save_path) and save_path!=null:
		var loaded_data=file.get_var()
		player_position_x=loaded_data.PLAYER_POS_X
		player_position_y=loaded_data.PLAYER_POS_Y
	if not FileAccess.file_exists(save_path):
		print('G.script: player position saver file doesnt exist,creating new player position save file')
		push_error('G.script: player position saver store file doesnt exist:creating one rn')
		#save_data()
		save_current_player_checkpoint_position()
#	print("e_tank no",energy_tank_number)
#	print("w_tank no",weapon_tank_number)
	#print("Data:",data)
var line_no=0
func load_tanks_values():
	line_no=0
	var file_values= FileAccess.open(current_save_file,FileAccess.READ)#and FileAccess.is_open() 
	if FileAccess.file_exists(current_save_file) and current_save_file!=null :
		#while file_values.get_position()<file_values.get_length():# not file_values.eof_reached():
			#line_no+=1
			#print_fxn_custom(name,'line_no \n',line_no)
		print(FileAccess.get_file_as_string(current_save_file))
		var loaded_data2=file_values.get_var()#file_values.get_var()
		var loaded_data2_txt=file_values.get_as_text()
		if loaded_data2!=null:
			if loaded_data2.has('LIFE_NO') and loaded_data2.has('ENERGY_TANK_NO') and loaded_data2.has('WEAPON_TANK_NO') and loaded_data2.has('MEGA_TANK_NUMBER') and loaded_data2.has('BOLT_NUMBER') and loaded_data2.has('ENERGY_BALANCER_NUMBER'):#loaded_data2.contains('ENERGY_TANK_NO')
				#if loaded_data2==null:
						#push_error("error:no data in player_value_save file:saving right now",energy_tank_number)
						#push_error("error:w_tank no",weapon_tank_number)
						#save_energy_weapon_tanks()
				
				if loaded_data2.ENERGY_TANK_NO!=null and loaded_data2.WEAPON_TANK_NO!=null and loaded_data2.LIFE_NO!=null:
					life=loaded_data2.LIFE_NO
					energy_tank_number=loaded_data2.ENERGY_TANK_NO
					weapon_tank_number=loaded_data2.WEAPON_TANK_NO
					mega_tank_number=loaded_data2.MEGA_TANK_NUMBER
					bolt_number=loaded_data2.BOLT_NUMBER
					print_fxn_custom(name,"loaded_data2",loaded_data2)
					#weaponsRunTimeValues["MAGPULSE"]=loaded_data2.MAGPULSE
				else:
					OS.move_to_trash(current_save_file)
					push_error('Save file doesnt have all values needed; creating new one')
					save_energy_weapon_tanks()
			else:
				OS.move_to_trash(current_save_file)
				push_error('Save file instance error 2: Save File Doesnt have all values needed; creating new Save File')
				save_energy_weapon_tanks()
	#creates a new save file if one doesnt exist and saves the player_values into it.
		#file_values.get_var()
		var loaded_data_weapons=file_values.get_var()
		print("loaded data weapons",loaded_data_weapons)
		if loaded_data_weapons!=null:
			#if loaded_data_weapons.has('5'):#"MAGPULSE"):
			#if loaded_data_weapons.has(weaponsRunTimeValues.keys()):
				#if loaded_data_weapons["5"]!=null:
			for values in loaded_data_weapons:
				if values!=null and weaponsRunTimeValues.has(values):
					#weaponsRunTimeValues["5"]=loaded_data_weapons.get("5")
					weaponsRunTimeValues[values]=loaded_data_weapons.get(values)
					print_fxn_custom(name,"loaded_data_weapons",loaded_data_weapons)
			#else:
				#OS.move_to_trash(save_file1)
				#push_error('Save file instance error 2: doesnt have all values needed; creating new one')
				#save_energy_weapon_tanks()
		else:
			OS.move_to_trash(current_save_file)
			push_error('Save file instance error 2: doesnt have all values needed; creating new one')
			save_energy_weapon_tanks()
	
	elif not FileAccess.file_exists(current_save_file):
		print('G.script: player value file doesnt exist,creating new player value file')
		push_error('G.script: player energy tank store file doesnt exist:creating one rn')
		save_energy_weapon_tanks()
	elif current_save_file==null:
		push_error('Second file path for tank values doesnt exist ')

func save_current_player_checkpoint_position():
	#code for saving Checkpoint data
	var file= FileAccess.open(save_path,FileAccess.WRITE)
	var player_data=create_player_data()
	file.store_var(player_data)
	#code below for debugging
	#print('Gscript: Player position stored!')
	#file.store_var(data)
	#file.close()

func save_energy_weapon_tanks():
	#code for saving data for tank,life and energy balancer data.
	var file2= FileAccess.open(current_save_file,FileAccess.WRITE)
	var player_data2=create_player_data_values()
	var weapons_save_progress=weaponsRunTimeValues
	file2.store_var(player_data2)
	file2.store_var(weapons_save_progress)

func create_player_data():
	var player_dict={
		"PLAYER_POS_X":player_position_x,
		"PLAYER_POS_Y":player_position_y,
	}
	return player_dict

func create_player_data_values():
	var player_dict2={
		'LIFE_NO':life,
		"ENERGY_TANK_NO":energy_tank_number,
		"WEAPON_TANK_NO":weapon_tank_number,
		'MEGA_TANK_NUMBER':mega_tank_number,
		'BOLT_NUMBER':bolt_number,
		'ENERGY_BALANCER_NUMBER':energy_balancer_number
	}
	return player_dict2

func write_values_as_text(value_name,value_to_stored):
	var string_text=str(value_name)
