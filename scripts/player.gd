extends KinematicBody2D

var sz_tl = Globals.sz_tl

var god_mode = false

var ACCELERATION = sz_tl*250
var GRAVITY = sz_tl*60
var FRICTION = sz_tl*750
var MOVE_SPEED = sz_tl*12.5
var FALL_SPEED = sz_tl*25
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

var JUMP_FORCE = sz_tl*30

func _physics_process(delta):
#
#	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
#	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
#	input_vector = input_vector.normalized()
#
#	if god_mode:
#		$CollisionShape2D.disabled = true
#
#		if input_vector != Vector2.ZERO:
#			velocity = velocity.move_toward(MAX_SPEED * input_vector, ACCELERATION * delta)
#		else:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#	else:
#		$CollisionShape2D.disabled = false
#
#		if Input.is_action_just_pressed("jump"):
#			velocity.y = -5*MAX_SPEED
#
#		if input_vector != Vector2.ZERO:
#			velocity.x = move_toward(velocity.x, MAX_SPEED * input_vector.x, ACCELERATION * delta)
#		else:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#
#		velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY * delta)
	
	$CollisionShape2D.disabled = god_mode
	
	if Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		velocity.x = MOVE_SPEED 
		$Sprite.flip_h = true
		$AnimationPlayer.play("run")
	elif Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		velocity.x = -MOVE_SPEED
		$Sprite.flip_h = false
		$AnimationPlayer.play("run")
	else:
		velocity.x = 0
		$AnimationPlayer.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_FORCE
	
	velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _input(event):
	if event.is_action_released("toggle_god_mode"):
		god_mode = !god_mode
