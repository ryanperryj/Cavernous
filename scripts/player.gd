extends KinematicBody2D

var sz_tl = Globals.sz_tl

var god_mode = false

const ACCELERATION = 1000
const GRAVITY = 1000
const FRICTION = 1000
const MAX_SPEED = 150
const FALL_SPEED = 500
const JUMP_FORCE = 400

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input == 0:
		$AnimationPlayer.play("idle")
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)
	else:
		$AnimationPlayer.play("run")
		$Sprite.flip_h = x_input > 0
		velocity.x = move_toward(velocity.x, MAX_SPEED * x_input, ACCELERATION * delta)
	
	#if on_floor:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -JUMP_FORCE
	
	velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _input(event):
	if event.is_action_released("toggle_god_mode"):
		god_mode = !god_mode
