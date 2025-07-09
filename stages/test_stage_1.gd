extends Node2D
var restart_stage_timer = 0
var boss_timer = 0
var health_boss_update_trigger = false
@onready var player_camera = $megaman/player_camera

signal boss_dead


# Called when the node enters the scene tree for the first time.
func _ready():
	if !GlobalScript.loaded_stage:
		if !GlobalScript.restarted_stage:
			#get_tree().change_scene_to_file("res://menus/loading_screen.tscn")
			GlobalScript.loaded_stage = true
	#GlobalScript.life=1
	$bg_test_stage1.play()
	#value_stream+=1

	#for i in stream_stuff and $bg_test_stage1.get_stream()==stream_stuff[i]:
	if stream_stuff.has(value_stream):
#		print(i,'....',stream_stuff[val])
		$bg_test_stage1.stream = stream_stuff.get(value_stream)
		$bg_test_stage1.play()
	#player_camera.position_smoothing_enabled=true


var timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value_stream = clamp(value_stream, 1, 2)
	#print("hello world")

	#print($bg_test_stage1.get_stream())
	#if GlobalScript.boss_health
	if GlobalScript.boss_health[1] <= 0:
		$all_doors/door5.set_physics_process(true)
		#$all_doors/door5.set
		$boss_mmf.stop()

		if timer < 5:
			timer += 1
		if timer == 1:
			$bg_test_stage1.play()
#		if $bg_test_stage1.
	else:
		$all_doors/door5.set_physics_process(false)

	if $bg_test_stage1.is_playing() == false:
		pass
	#change volume(temp.code)
#	if Input.is_action_just_pressed("move_up"):
#		$bg_test_stage1.volume_db+=0.1
#	if Input.is_action_pressed("move_down"):
#		$bg_test_stage1.volume_db-=0.1

	if GlobalScript.health <= 0:
		$bg_test_stage1.stop()
		StageFunctions.stop_music($boss_battle)
		StageFunctions.stop_music($boss_mmf)

	if $green_devil_proto.health <= 0:
		StageFunctions.stop_music($boss_battle)

	if trigger_boss == true:
		boss_timer += 1
		if boss_timer > 30 and boss_timer < 200:
			$megaman.stop = true

		if boss_timer == 200:
			$megaman.stop = false
			boss_music_started = true
			$green_devil_proto/hitbox/CollisionShape2D.disabled = true
			$green_devil_proto.stop_moving = false
			trigger_boss = false
	if $green_devil_proto.change_animations == 300:  #creates tween for increasing health
		var tween = create_tween()
		tween.tween_property(
			$megaman/player_camera/hud/boss_healthbar, "value", $green_devil_proto.max_health, 2
		)
		tween.connect("finished", tween_gdevil_finish)
	if $green_devil_proto.change_animations > 300 and $green_devil_proto.change_animations < 500:
		$megaman/player_camera/hud/boss_healthbar.visible = true
		$megaman/player_camera/hud/health_backup3.visible = true

		if $green_devil_proto.change_animations % 5 == 1:
			if $megaman/player_camera/hud/boss_healthbar.value <= 30:
				$megaman/all_sound_effects/healthup.play()
				#$megaman/player_camera/hud/boss_healthbar.value+=1
	if $green_devil_proto.change_animations == 499:
		$megaman.stop = false

		health_boss_update_trigger = true
		$green_devil_proto/hitbox/CollisionShape2D.disabled = false
		#$megaman/player_camera/hud/boss_healthbar.value=$green_devil_proto.health
#	if $megaman/player_camera/hud/boss_healthbar.value>30:
#		$megaman/player_camera/hud/boss_healthbar.value=30
	if health_boss_update_trigger == true:
		$megaman/player_camera/hud/boss_healthbar.value = $green_devil_proto.health
	if boss_music_started == true:
		#print(change_timer)
		if change_timer < 30:
			change_timer += 1
			if change_timer == 1:
				trigger_boss = false
				#StageFunctions.change_music($bg_test_stage1,$boss_battle)
	if $green_devil_proto.health <= 0:
		$megaman.about_to_leave = true


var has_entered = false
var boss_music_started = false
#func _on_area_2d_body_entered(body):
#	if body.is_in_group("player"):
#		if has_entered==false:
#

#func _on_zone_1_area_entered(area):
#	if area.is_in_group('player_camera_transition_hitbox'):
#		StageFunctions.switch_camera(player_camera,camera_1)
#		$megaman/transition_screen_timer.start()

#func _on_zone_1_body_entered(body):
#	if body.is_in_group("player"):
#		pass

var trigger_boss = false


func _on_zone_4_body_entered(body):
	if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera, camera_4)
		trigger_boss = true


var i: int
var j: AudioStream

@export var stream_stuff = {}
var value_stream: int = 1


func _on_bg_test_stage_1_finished():
	#print('bg test stage:on')
	#if value_stream<2:
	#value_stream+=1
	##value_stream=clamp(value_stream,1,2)
	##for i in stream_stuff and $bg_test_stage1.get_stream()==stream_stuff[i]:
	#if stream_stuff.has(value_stream) :
##		print(i,'....',stream_stuff[val])
	#$bg_test_stage1.stream=stream_stuff.get(value_stream)
	$bg_test_stage1.play()


var change_timer = 0


func _on_zone_5_body_entered(body):
	if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera, camera_5)
		pass


#		if body.velocity.y<0:
#			print("megaman moving up")
#			body.moving_up=true
#		if body.velocity.y>0:
#			print("megaman moving down")
#			body.moving_down=true


func _on_zone_5_body_exited(body):
	if body.is_in_group("player"):
		body.moving_up = false
		body.moving_down = false
		body.stop = false


func _on_zone_2_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		#StageFunctions.switch_camera(player_camera, camera_2)
		$megaman/transition_screen_timer.start()


func _on_zone_3_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		#StageFunctions.switch_camera(player_camera, camera_3)
		$megaman/transition_screen_timer.start()


func _on_zone_5_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		#StageFunctions.switch_camera(player_camera, camera_5)
		$megaman/transition_screen_timer.start()


func _on_zone_6_area_entered(area):
	if area.is_in_group("player_camera_transition_hitbox"):
		#StageFunctions.switch_camera(player_camera, camera_6)
		$megaman/transition_screen_timer.start()


#########################################################################################


func tween_gdevil_finish():
	print("tween_gdevil:finished!")
	$megaman/player_camera/hud/boss_healthbar.max_value = $green_devil_proto.max_health
	$megaman/player_camera/hud/boss_healthbar.value = $green_devil_proto.health


func _on_trans_zone_5_body_entered(body):
	if body.is_in_group("player"):
		#StageFunctions.switch_camera(player_camera, camera_5)
		pass


func _on_bossstart_body_entered(body):
	if body.is_in_group("player"):
		$bg_test_stage1.stop()
		$boss_mmf.play()
		var tween = create_tween()
		tween.tween_property($megaman/player_camera/hud/boss_healthbar, "value", 26, 1)
		$"boss-start/start-boss".start()
		$"boss-start/CollisionShape2D".set_deferred("disabled", true)
		#$"boss-start/CollisionShape2D".disabled=true


func _on_startboss_timeout():
	$mini_yellow_devil/timer_start.start()


func _on_boss_mmf_finished():
	$bg_test_stage1.play()
