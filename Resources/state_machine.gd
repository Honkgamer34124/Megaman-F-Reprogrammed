extends Node
@export var initial_movement_state: State
@export var initial_attack_state: State
var current_movement_state: State
var current_attack_state: State
var states: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:  # if child is a State, add to dictionary with its key being its name.
			states[child.name.to_lower()] = child
			child.transition.connect(transitioning_states)
	if initial_movement_state:
		initial_movement_state.Enter()
		current_movement_state = initial_movement_state
		print("current movement state:", current_movement_state)
	if initial_attack_state:
		initial_attack_state.Enter()
		current_attack_state = initial_attack_state
		print("Current attack state", current_attack_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_movement_state:  # update movement state
		current_movement_state.Update(delta)
	if current_attack_state:  # update attack state
		current_attack_state.Update(delta)


func _physics_process(delta):
	if current_movement_state:
		current_movement_state.Physics_Update(delta)
	if current_attack_state:
		current_attack_state.Physics_Update(delta)
	print(
		name,
		":Current movement state,Current attack state:",
		[current_movement_state, current_attack_state]
	)


func transitioning_states(state, new_incoming_state):
	if state == current_movement_state:
		var new_state = states.get(new_incoming_state.to_lower())
		if !new_state:
			return
		if current_movement_state:
			current_movement_state.Exit()
		new_state.Enter()
		current_movement_state = new_state
		print(name, ":Current movement state:", current_movement_state)
	elif state == current_attack_state:
		var new_state = states.get(new_incoming_state.to_lower())
		if !new_state:
			return
		if current_attack_state:
			current_attack_state.Exit()
		new_state.Enter()
		current_attack_state = new_state
		print(name, ":Current attack state:", current_attack_state)
