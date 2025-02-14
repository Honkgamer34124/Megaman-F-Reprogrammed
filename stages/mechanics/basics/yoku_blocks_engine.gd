extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	if get_node(group_container[index_of_group])!=null:
#		for i in get_node(group_container[index_of_group]).get_children():
#			i.visible=true
#	for i in index_of_group:
#		if i != index_of_group:
#			get_node(group_container[index_of_group])
#	if get_node(group_container[index_of_group])
#
	
	match index_of_group:
		1:
			$all_yoku_blocks/group1.visible=true
			$all_yoku_blocks/group2.visible=false
			$all_yoku_blocks/group3.visible=false
		2:
			$all_yoku_blocks/group1.visible=false
			$all_yoku_blocks/group2.visible=true
			$all_yoku_blocks/group3.visible=false
		3:
			$all_yoku_blocks/group1.visible=false
			$all_yoku_blocks/group2.visible=false
			$all_yoku_blocks/group3.visible=true
	if index_of_group>3:
		index_of_group=1
	
var index_of_group=1
@export var group_container={}
func _on_visibility_timer_timeout():
	index_of_group+=1
