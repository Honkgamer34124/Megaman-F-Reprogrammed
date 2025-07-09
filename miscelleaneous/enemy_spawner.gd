@tool
extends CharacterBody2D
##Collects the name of the enemy to spawn
@export_enum("met", "flea", "joe_bot", "batton", "shield_attacker_gtr", "telly")
var enemy_to_spawn: String = ""
@export var visibility: bool = true
##This sets the enemy's index to the spawner to detect enemy deletion.
var enemy_spawn_number = 0
var enemy_spawned = false
var enemy_dictionary = {
	"met": preload("res://enemies/met.tscn"),
	"flea": preload("res://enemies/flea.tscn"),
	"joe_bot": preload("res://enemies/joe_bot.tscn"),
	"batton": preload("res://enemies/batton.tscn"),
	"shield_attacker_gtr": preload("res://enemies/shield_attacker_gtr.tscn"),
	"telly": preload("res://enemies/telly.tscn")
}
var new_enemy
var activate_spawn_timer = 0
var enemy_spawner_on_screen: bool = false
var startedRespawnTimer: bool = false
var enemyPreview: Node


func _physics_process(delta):
	if Engine.is_editor_hint():
		self.visible = visibility
		$AnimatedSprite2D.visible = visibility
		pass
		if enemy_to_spawn != null and enemy_to_spawn != "":
			if enemyPreview == null:
				enemyPreview = enemy_dictionary[enemy_to_spawn].instantiate()
				add_child(enemyPreview)
				enemyPreview.global_position = global_position
		else:
			if enemyPreview != null:
				enemyPreview.queue_free()
		if enemyPreview != null:
			if enemyPreview.scale > Vector2(1, 1):
				enemyPreview.scale = Vector2(1, 1)
			if enemy_to_spawn == "joe_bot":
				enemyPreview.scale = Vector2(.3, .3)
			#print(enemyPreview.scale)

	if not Engine.is_editor_hint():
		$AnimatedSprite2D.visible = false
		self.visible = visibility
		if enemy_spawner_on_screen and not GlobalScript.transitioning:
			activate_spawn_timer += 1 * delta
			if activate_spawn_timer < 0.1 and enemy_spawned == false:
				if enemy_dictionary.has(enemy_to_spawn):
					var enemyInstance = enemy_dictionary[enemy_to_spawn]
					new_enemy = enemyInstance.instantiate()
					new_enemy.position = position
					get_parent().add_child(new_enemy)
					enemy_spawned = true
					#debugging for new enemies being spanwed using the new_enemy var. and the enemy_to_spawn text selector.
					if new_enemy:
						print("enemy spawner:enemy:", enemy_to_spawn, "::spawned")
		elif not enemy_spawner_on_screen:
			activate_spawn_timer = 0
		#checks if enemy dead and deacivates enemy spawner..for now
		if new_enemy == null and enemy_spawner_on_screen:
			enemy_spawned = false

		if new_enemy != null:
			if GlobalScreenTransitionTimer.time_left > 0:
				new_enemy.set_physics_process(false)
			elif GlobalScreenTransitionTimer.time_left <= 0:
				new_enemy.set_physics_process(true)

	##debugging for dead enemies

	$AnimatedSprite2D.play("default")
	#this code respawns tellys if
	# there's no telly existing,we haven't started enemyrespawnTimer
	#and the enemy spawner is on screen.
	if enemy_to_spawn == "telly":
		if (
			new_enemy == null
			and enemy_spawned == false
			and startedRespawnTimer == false
			and enemy_spawner_on_screen == true
		):
			$timers/enemyRespawnTimer.start()
			startedRespawnTimer = true
		if enemy_spawner_on_screen == false:
			$timers/enemyRespawnTimer.stop()


func _on_visible_on_screen_notifier_2d_screen_entered():
	#when the spawner enters the screen of megaman,the enemy_spawner_on_screen code
	# gets to be true
	enemy_spawner_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	enemy_spawner_on_screen = false


func _on_enemy_respawn_timer_timeout() -> void:
	activate_spawn_timer = 0
	startedRespawnTimer = false
