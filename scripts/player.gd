extends KinematicBody2D

var ACCELERATION = 16*500
var FRICTION = 16*750
var MAX_SPEED = 16*50
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	set_process(true)

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(MAX_SPEED * input_vector, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
