extends Node2D
@onready var player_camera=$megaman/player_camera
#@onready var camera_3 = $all_camera_zones/camera3
@onready var background_music = $background_music


# Called when the node enters the scene tree for the first time.
func _ready():
	background_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($all_new_camera_systems/camera_system2/CollisionShape2D.get_shape())
	pass

func _on_camera_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		$megaman/transition_screen_timer.start()
		#StageFunctions.switch_camera(player_camera,camera)


func _on_camera_2_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		$megaman/transition_screen_timer.start()
		#StageFunctions.switch_camera(player_camera,camera_2)

func _on_camera_3_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		$megaman/transition_screen_timer.start()
		#StageFunctions.switch_camera(player_camera,camera_3)


func _on_background_music_finished():
	background_music.play()
