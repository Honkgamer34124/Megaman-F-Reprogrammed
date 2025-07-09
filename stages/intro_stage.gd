extends Node2D
@onready var background_music = $background_music
@onready var player_camera = $megaman/player_camera
#@onready var camera_5 = $all_camera/camera5
#@onready var camera_6 = $all_camera/camera6
@onready var camera_7 = $all_camera/camera7
@onready var camera_8 = $all_camera/camera8
@onready var camera_9 = $all_camera/camera9
@onready var camera_10 = $all_camera/camera10
@onready var camera_11 = $all_camera/camera11
@onready var camera_12 = $all_camera/camera12

var directory: Dictionary = {
	"intro_music":
	preload("res://assets/music/Mega Man F (Original Soundtrack) - Intro Stage Theme(Youtube).mp3")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	$background_music.stream = directory.get("intro_music")
	$background_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalScript.health <= 0:
		$background_music.stop()
	if GlobalScript.boss_health[1] <= 0:
		$megaman.isAboutToLeave = true
		background_music.stop()


func _on_background_music_finished():
	background_music.play()


func _on_zone_3_body_entered(body):
	pass


func _on_savepoint_2_body_entered(body):
	if body.is_in_group("player"):
		pass


func _on_zone_2_body_entered(body):
	pass


func _on_mini_yellow_trigger_timeout():
	$megaman/player_camera/hud.freezeTime()
	$megaman/player_camera/hud.doFancyBossHealthBarFill()
	$bosses/mini_yellow_devil/timer_start.start()


func _on_boss_music_start_timeout():
	pass  # Replace with function body.
	background_music.stream = preload("res://assets/music/Megaman F Boss Battle theme-YouTube.mp3")
	background_music.play()
	$bosses/boss_trigger_timer/mini_yellow_trigger.start()


func _on_camera_system_23_area_entered(area: Area2D) -> void:
	pass


func _on_entryplayer_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_camera_transition_hitbox"):
		$bosses/boss_trigger_timer/boss_music_start.start()


func _on_freeze_time_timeout() -> void:
	#unfreezeTime()
	pass
