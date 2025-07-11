extends CharacterBody2D
class_name enemy
var state = ""
var health = 1
var playerdamage_value = 1
var boss_damamgevalue = 0
var enemy_name: String = ""
var index = 0
var s_health_capsule = preload("res://miscelleaneous/small_health_capsule.tscn")
var l_health_capsule = preload("res://miscelleaneous/large_health_capsule.tscn")
var life_up = preload("res://miscelleaneous/life_up.tscn")
var small_weapon_capsule = preload("res://miscelleaneous/small_weapon_capsule.tscn")
var large_weapon_capsule = preload("res://miscelleaneous/large_health_capsule.tscn")
var small_bolt = preload("res://miscelleaneous/tiny_bolt.tscn")
var large_bolt = preload("res://miscelleaneous/large_bolt.tscn")
var enemy_death_timer = 0
var explosion = preload("res://enemies/death_explosion_enemy.tscn")
var explosion_new
var collectables_dictionary = {
	1: preload("res://miscelleaneous/small_health_capsule.tscn"),
	2: preload("res://miscelleaneous/large_health_capsule.tscn"),
	3: preload("res://miscelleaneous/life_up.tscn"),
	4: preload("res://miscelleaneous/small_weapon_capsule.tscn"),
	5: preload("res://miscelleaneous/large_weapon_capsule.tscn"),
	6: preload("res://miscelleaneous/tiny_bolt.tscn"),
	7: preload("res://miscelleaneous/large_bolt.tscn"),
}
var is_boss: bool = false
var boss_defense: int = 0
var boss_defense_lvl_one_chargeshot: int = 0
var player_distance_x: float = 0
var player_distance_y: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health < 0:
		health = 0
		#print("nb")
	if health <= 0:
		#print("enemy_template:reduce spawn no:")
		pass


var new_collectable
var delete_timer


func spawn_collectables():
#creates  collectbles,also reduce the enemey 's spawn no
	if is_queued_for_deletion():
		explosion_new = explosion.instantiate()
		get_parent().add_child(explosion_new)
		explosion_new.global_position = global_position

	if health <= 0:
		#create_death_effect()
		#creates an explosion if an enemy dies

		explosion_new = explosion.instantiate()
		get_parent().add_child(explosion_new)
		explosion_new.global_position = global_position
		GlobalScript.item_randomizer = randi_range(1, 14)
		queue_free()
		#queue_free()
		#get_tree().call_group("enemy_spawners","reduce_spawn_number",index)
		#var s_health_capsule_instance=s_health_capsule.instantiate()
		#var l_health_capsule_instance=l_health_capsule.instantiate()
		#var life_up_instance= life_up.instantiate()
		#var small_w_capsule_instance=small_weapon_capsule.instantiate()
		#var small_bolt_instance=small_bolt.instantiate()
		#var large_bolt_instance=large_bolt.instantiate()
		#$hurt_enemy.play()
		#
		#
		#if GlobalScript.item_randomizer==2:
		#get_parent().add_child(s_health_capsule_instance)
		#s_health_capsule_instance.global_position=global_position
		#GlobalScript.item_randomizer=1
		#if GlobalScript.item_randomizer==3:
		#get_parent().add_child(l_health_capsule_instance)
		#l_health_capsule_instance.global_position=global_position
		#GlobalScript.item_randomizer=1
		#if GlobalScript.item_randomizer==4:
		#get_parent().add_child(life_up_instance)
		#life_up_instance.global_position=global_position
		#GlobalScript.item_randomizer=1
		#if GlobalScript.item_randomizer==5:
		#get_parent().add_child(small_w_capsule_instance)
		#small_w_capsule_instance.global_position=global_position
		#GlobalScript.item_randomizer=1
		#if GlobalScript.item_randomizer==6:
		#get_parent().add_child(small_bolt_instance)
		#small_bolt_instance.global_position=global_position
		#GlobalScript.item_randomizer=1
		#if GlobalScript.item_randomizer==7:
		#get_parent().add_child(large_bolt_instance)
		#large_bolt_instance.global_position=global_position
		#GlobalScript.item_randomizer=1
		if collectables_dictionary.has(GlobalScript.item_randomizer):
			var collectable = collectables_dictionary[GlobalScript.item_randomizer]
			new_collectable = collectable.instantiate()
			new_collectable.position = position
			get_parent().add_child(new_collectable)
			const DELETE_COLLECTABLE_TIMER = preload(
				"res://miscelleaneous/delete_collectable_timer.tscn"
			)

			var delete_timer_instance = DELETE_COLLECTABLE_TIMER.instantiate()
			new_collectable.add_child(delete_timer_instance)
			#start_delete_timer.emit()
			#delete_timer=Timer.new()
			#
			#delete_timer.connect("timeout",new_collectable.delete_collectable)
			#new_collectable.add_child(delete_timer)
			#
			#delete_timer.wait_time=3
			#delete_timer.one_shot=true
			##delete_timer.autostart=true
			#delete_timer.start()
			#

			#new_collectable.add_child(delete_timer)
			GlobalScript.item_randomizer = 0


func calculate_player_distance():
	player_distance_x = GlobalScript.player_position_x - global_position.x
	player_distance_y = global_position.y - GlobalScript.player_position_y


signal start_delete_timer

#func create_death_effect():
#	var death_effect:AudioStreamPlayer
#	get_parent().add_child(death_effect)
#	death_effect.stream=preload('res://assets/sounds/death_mm_robot_master_mm3-10.mp3')
#	death_effect.play()
