@tool
extends Area2D
@export var player_camera:Camera2D
@export var player_timer:Timer
@onready var camera = $camera
var player_camera_node

var player:CharacterBody2D
var timer:int
##Camera2D node that is used by the node to set camera zones in the game.
@export var zone_camera_2d :Camera2D
##CollisionShape2D node that sets the Zone Camera's limits. Is found automatically.
@export var collision_limits_camera:CollisionShape2D
##GlobalTimerchecker which checks if you've declared a GlobalScreenTransitionTimer in your game as a global variable.
@export var Transition_Timer :Timer#GlobalTimerChecker
##A float variable which is used to set up how often this node updates itself esp.its settings.
var time_offset:float=0
##Camera Limit on the left set by the CollisionShape2D.
var limit_l=0;
##Camera Limit on the right set by the CollisionShape2D.
var limit_r=0;
##Camera Limit on the top set by the CollisionShape2D.
var limit_u=0;
##Camera Limit on the bottom set by the CollisionShape2D.
var limit_d=0;




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#player_camera_node=get_parent().get_parent().get_node('megaman/player_camera')
	if zone_camera_2d==null:
		zone_camera_2d=get_node_or_null("camera")
	if collision_limits_camera==null:
		collision_limits_camera=get_node_or_null("CollisionShape2D")
	if collision_limits_camera!=null and collision_limits_camera.get_shape() is RectangleShape2D:
		
		#print(collision_limits_camera,"[collisions_limits_camera]:",collision_limits_camera.get_shape())
		#player_camera.limit_left=
		#print(name,":get_rect().position.x->",collision_limits_camera.shape.get_rect().position.x)
		var pos_x=collision_limits_camera.global_position.x#abs(collision_limits_camera.shape.get_rect().position.x)
		var pos_y=collision_limits_camera.global_position.y#abs(collision_limits_camera.shape.get_rect().position.y)
		var size_l=collision_limits_camera.shape.get_rect().size.x
		var size_h=collision_limits_camera.shape.get_rect().size.y
		limit_l=pos_x-(size_l/2); limit_r=pos_x+(size_l/2)
		limit_u=pos_y-(size_h/2); limit_d=pos_y+(size_h/2)
		#zone_camera_2d.limit_left=limit_l
		if zone_camera_2d!=null:
			zone_camera_2d.set("limit_left",limit_l)
			zone_camera_2d.set("limit_right",limit_r)
			#zone_camera_2d.set("zone_camera_2d.limit_right",limit_r)
			#zone_camera_2d.limit_right=limit_r
			zone_camera_2d.limit_top=limit_u
			zone_camera_2d.limit_bottom=limit_d
			#$Camera2D.notify_property_list_changed() #updates inspector and editor
			#zone_camera_2d.notify_property_list_changed()

func _on_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		player_camera=area.get_parent().get_node('player_camera')
		#player_camera=Viewport.get_camera_2d()
		if player_camera!=null and zone_camera_2d!=null:
			StageFunctions.switch_camera(player_camera,zone_camera_2d)
			GlobalScreenTransitionTimer.start()
			#print(name,"[cam_system]:player_cam:",player_camera.name)
		else:
			push_error(get_tree().get_current_scene().name,".",name,"-->Player camera cannot be detected")
