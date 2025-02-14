extends Node2D
@onready var animated_menu = $animated_menu
@onready var press_start_text = $press_start_text
@onready var press_start_menu_bgm = $press_start_menu_bgm

var blink_timer = 0
var timer = 0
var start_timer = false


# Called when the node enters the scene tree for the first time.
func _ready():
	press_start_menu_bgm.play()
	animated_menu.play("animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	blink_timer += 1
	if start_timer == false:
		if blink_timer % 10 == 1:
			press_start_text.visible = false
		elif blink_timer % 10 == 5:
			press_start_text.visible = true
	elif start_timer == true:
		if blink_timer % 5 == 1:
			press_start_text.visible = false
		elif blink_timer % 5 == 3:
			press_start_text.visible = true

	if Input.is_action_just_pressed("confirm"):
		if start_timer == false:
			press_start_menu_bgm.stop()
			start_timer = true
	if start_timer == true:
		timer += 1
		if timer == 50:
			var tween = create_tween()
			tween.tween_property(self, "modulate", Color(0, 0, 0, 255), 0.5)
		if timer == 100:
			get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _on_press_start_menu_bgm_finished():
	press_start_menu_bgm.play()


func _on_press_start_animation_player_animation_changed(_old_name, _new_name):
	pass  # Replace with function body.


func _on_press_start_animation_player_animation_finished(anim_name):
	match anim_name:
		"FadeOutMenuEffect":
			get_tree().change_scene_to_file("res://menus/story_demo_scene.tscn")


func _on_countdown_to_demo_timer_timeout():
	$PressStartAnimationPlayer.play("FadeOutMenuEffect")
