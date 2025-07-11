extends Node
@export var initial_state: State
var current_state: State
#var new_incoming_state:State
var states: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:  #if child is a State,add to dictionary with its key being its name.
			states[child.name.to_lower()] = child
			child.transition.connect(transitioning_states)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
		print("current state:", current_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:  #if state==current_state,update it
		current_state.Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		#print(name, "current_state:", current_state)


func transitioning_states(state, new_incoming_state):
	if state != current_state:  #checks that state entered==current state
		return

	var new_state = states.get(new_incoming_state.to_lower())
	if !new_state:  #checks if the new state we are transitioning to is in the states dictionary/not
		return
	if current_state:
		current_state.Exit()
	new_state.Enter()
	current_state = new_state
	print(name, ":Current state:", current_state)
