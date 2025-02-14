extends Node
var rush_coil_on_screen=false
var chargetimer=0;var effect_chargetimer=0
var weapon_number=1
var weapon_energy:Dictionary={
	1:27,2:27,3:27,4:27,5:27,
	6:27,7:27,8:27,
	9:27,10:27,11:27
}
var weapon_color_dictionary_bodycolor1:Dictionary={
	1:Vector4(121,150,156,255),2:Vector4.ZERO,3:Vector4.ZERO,4:Vector4.ZERO,5:Vector4.ZERO,
	6:Vector4(190,162,255,255),7:Vector4.ZERO,8:Vector4.ZERO,
	9:Vector4(255,255,255,255),10:Vector4(255,255,255,255)
}
var weapon_color_dictionary_bodycolor2:Dictionary={
	1:Vector4(173,231,24,255),2:Vector4.ZERO,3:Vector4.ZERO,4:Vector4.ZERO,5:Vector4.ZERO,
	6:Vector4(136,23,250,255),7:Vector4.ZERO,8:Vector4.ZERO,
	9:Vector4(217,35,0,255),10:Vector4(217,35,0,255)
}

var weapons_to_GScript_runtime_values={
	6:'MAGPULSE',
	10:'RUSH_JET'
}

#@export_enum("LIGHT_VIOLET:")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	restrict_weapon_energy()
	check_if_weapon_obtained()
	#print(name,"chargetimer",chargetimer)
	
var CHARGEEFFECT_COLORS={
	"VIOLET":Vector4(135.0,0.0,142.0,255.0),#Vector4(0.0,98.0,247.0,255.0),
	"BLACK":Vector4(0.0,0.0,0.0,0.0),
	"LIGHT_BLUE":Vector4(136.0,232.0,255.0,255.0),
	"SEA_BLUE":Vector4(0.0,98.0,247.0,255.0)
}

func chargeeffect(animated_sprite:AnimatedSprite2D):
	#print('fmod(chargetimer): ',fmod(chargetimer,.3))
	if chargetimer==0:
		animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		animated_sprite.material.set_shader_parameter("chargecolorI",CHARGEEFFECT_COLORS.LIGHT_BLUE/255)#(Vector4(136.0,232.0,255.0,255.0))
		animated_sprite.material.set_shader_parameter("chargecolorII",CHARGEEFFECT_COLORS.SEA_BLUE/255)#(Vector4(0.0,98.0,247.0,255.0))
	elif chargetimer>0.5 and chargetimer<1:
		if effect_chargetimer%10==1:#is_equal_approx(fmod(chargetimer,0.2),.1):
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif effect_chargetimer%10==5:#is_equal_approx(fmod(chargetimer,0.2),.2):
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",CHARGEEFFECT_COLORS.VIOLET/255)#(Vector4(135.0,0.0,142.0,255.0))
	elif chargetimer>1 and chargetimer<=1.75:
		if effect_chargetimer%10==1:
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif effect_chargetimer%10==5:#is_equal_approx(fmod(chargetimer,0.2),.2):
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif chargetimer>1.75:
		#animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		if effect_chargetimer%10==1:#is_equal_approx(fmod(chargetimer,0.3),.1): #fmod(chargetimer,0.3)==0.1:
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(137.0,233.0,255.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorI",(Vector4(0.0,98.0,247.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorII",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif effect_chargetimer%10==4:#is_equal_approx(fmod(chargetimer,0.3),.2):
			animated_sprite.material.set_shader_parameter("chargecolorI",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorII",(Vector4(137.0,233.0,255.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,98.0,247.0,255.0))/255)
		elif effect_chargetimer%10==7:#is_equal_approx(fmod(chargetimer,0.3),.3):
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorI",(Vector4(136.0,232.0,255.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorII",(Vector4(0.0,98.0,247.0,255.0))/255)
func change_color_palette(animated_sprite:AnimatedSprite2D):
	animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
	animated_sprite.material.set_shader_parameter("chargecolorI",(weapon_color_dictionary_bodycolor1.get(weapon_number))/255)
	animated_sprite.material.set_shader_parameter("chargecolorII",(weapon_color_dictionary_bodycolor2.get(weapon_number))/255)

func change_color_palette_other_nodes(other_node:Node2D):
	other_node.material.set_shader_parameter("chargecolorI",(weapon_color_dictionary_bodycolor1.get(weapon_number))/255)
	other_node.material.set_shader_parameter("chargecolorII",(weapon_color_dictionary_bodycolor2.get(weapon_number))/255)

func change_color_palette_progressbars_hud(progress_bar_node:TextureProgressBar):
	progress_bar_node.material.set_shader_parameter("chargecolorI",(weapon_color_dictionary_bodycolor1.get(weapon_number))/255)
	progress_bar_node.material.set_shader_parameter("chargecolorII",(weapon_color_dictionary_bodycolor2.get(weapon_number))/255)

func chargeeffect_sprite(sprite2d:Sprite2D):
	if chargetimer==0:
		sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		sprite2d.material.set_shader_parameter("chargecolorI",(Vector4(136.0,232.0,255.0,255.0))/255)
		sprite2d.material.set_shader_parameter("chargecolorII",(Vector4(0.0,98.0,247.0,255.0))/255)
	elif chargetimer>0 and chargetimer<30:
		if chargetimer%10==1:
			sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif chargetimer%10==5:
			sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif chargetimer>30 and chargetimer<75:
		if chargetimer%10==1:
			sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif chargetimer%10==5:
			sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif chargetimer>75:
		#animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		if chargetimer%10==1:
			sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(137.0,233.0,255.0,255.0))/255)
			sprite2d.material.set_shader_parameter("chargecolorI",(Vector4(0.0,98.0,247.0,255.0))/255)
			sprite2d.material.set_shader_parameter("chargecolorII",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif chargetimer%10==4:
			sprite2d.material.set_shader_parameter("chargecolorI",(Vector4(0.0,0.0,0.0,255.0))/255)
			sprite2d.material.set_shader_parameter("chargecolorII",(Vector4(137.0,233.0,255.0,255.0))/255)
			sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,98.0,247.0,255.0))/255)
		elif chargetimer%10==7:
			sprite2d.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
			sprite2d.material.set_shader_parameter("chargecolorI",(Vector4(136.0,232.0,255.0,255.0))/255)
			sprite2d.material.set_shader_parameter("chargecolorII",(Vector4(0.0,98.0,247.0,255.0))/255)

var current_state_of_weapon
func check_if_weapon_obtained():
	#GlobalScript.print_fxn_custom(name,'current_state_of_weapon,weapon_no',[current_state_of_weapon,weapon_number])
	#GlobalScript.print_fxn_custom(name,'runtime_values(weapons)',GlobalScript.weaponsRunTimeValues)
	#for i in GlobalScript.weaponsRunTimeValues:
		#if GlobalScript.weaponsRunTimeValues.has
	#for i in GlobalScript.weaponsRunTimeValues:
		#if 
	if GlobalScript.weaponsRunTimeValues.has(str(weapon_number)):
		current_state_of_weapon=GlobalScript.weaponsRunTimeValues[str(weapon_number)]
		
	pass

func reset_weapon_energy():
	for i in weapon_energy:
		if weapon_energy.has(i):
			#if i!=2:
				weapon_energy[i]=27
var limit_weapons=8
func restrict_weapon_energy():
#			if weapon_energy[2]>27: weapon_energy[2]=27
#			if weapon_energy[3]>27: weapon_energy[3]=27
	for i in weapon_energy:
		if weapon_energy.has(i):
			if weapon_energy[i]>=27:
				weapon_energy[i]=27
