extends KinematicBody2D

onready var World_ptr = self.get_parent()

var sz_tl = Globals.sz_tl

var god_mode = false

const ACCELERATION = 1000
const GRAVITY = 1000
const FRICTION = 1000
const FALL_SPEED = 500
const JUMP_FORCE = 400
var MAX_SPEED = 200

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

var tl_type_placing = Globals.STONE
var sel_tl = Vector2.ZERO

enum {R, L, F}
var facing_dir = F
var using = false

signal damage_tile
signal break_tile
signal place_tile

func _ready():
	$Timer_Break.paused = true

func _process(delta):
	sel_tl = World_ptr.get_sel_tl()

func _physics_process(delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_input = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	$Sprites/Body_and_Head/ArmRPivot/ArmR.visible = !using
	$Sprites/Body_and_Head/UseArmPivot/UseArm.visible = using
	
	if using:
		if get_global_mouse_position().x > position.x:
			facing_dir = R
		else:
			facing_dir = L
	else:
		if y_input != 0:
			facing_dir = F
	
	if x_input == 0:
		if facing_dir == F:
			$AP_Body.play("idleF")
		elif facing_dir == R:
			$AP_Body.play("idleR")
			$AP_UseArm.play("useR")
		elif facing_dir == L:
			$AP_Body.play("idleL")
			$AP_UseArm.play("useL")
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)
	else:
		if !using:
			if x_input > 0:
				facing_dir = R
			elif x_input < 0:
				facing_dir = L
		
		if facing_dir == R:
			$AP_Body.play("runR")
			$AP_UseArm.play("useR")
		elif facing_dir == L:
			$AP_Body.play("runL")
			$AP_UseArm.play("useL")
		velocity.x = move_toward(velocity.x, MAX_SPEED * x_input, ACCELERATION * delta)
	
	if god_mode:
		if y_input == 0:
			velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
		else:
			velocity.y = move_toward(velocity.y, -MAX_SPEED * y_input, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY * delta)
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				velocity.y = -JUMP_FORCE
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	## block breaking and placing ##
	
	if Input.is_action_pressed("break_tile"):
		using = true
		if !World_ptr.is_air(sel_tl):
			if $Timer_Break.is_paused():
				$Timer_Break.paused = false
				$Timer_Break.start(get_break_time())
			if $Timer_Break.is_stopped():
				$Timer_Break.paused = true
				emit_signal("break_tile")
				print("Player: emitted signal 'break_tile'")
	
	if Input.is_action_just_released("break_tile"):
		using = false
		$Timer_Break.paused = true
	
	if Input.is_action_pressed("place_tile"):
		using = true
		if World_ptr.is_air(sel_tl):
			emit_signal("place_tile", tl_type_placing)
			print("Player: emitted signal 'place_tile', tile type = ", tl_type_placing)
		else:
			print("Player: failed to place tile")
	
	if Input.is_action_just_released("place_tile"):
		using = false
	
	if Input.is_action_pressed("select_tile"):
		if !World_ptr.is_air(sel_tl):
			tl_type_placing = World_ptr.get_tl_type(sel_tl)
			print("Player: selected tile', tile type = ", tl_type_placing)
		print("Player: failed to select tile", tl_type_placing)
	
	## check for god mode ##
	
	if Input.is_action_just_released("toggle_god_mode"):
		god_mode = !god_mode
		$CS_Body.disabled = god_mode
		if god_mode:
			MAX_SPEED = 500
		else:
			MAX_SPEED = 200

func get_break_time():
	var tl_type = World_ptr.get_tl_type(sel_tl)
	
	if god_mode:
		return .005
	
	if tl_type == Globals.DIRT:
		return .25
	elif tl_type == Globals.STONE_DIRTY:
		return .5
	elif tl_type == Globals.STONE:
		return .75
	elif tl_type == Globals.STONE_DARK:
		return 1
