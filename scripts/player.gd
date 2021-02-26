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

var tl_type_placing = Globals.STONE
var sel_tl = Vector2.ZERO

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

signal damage_tile
signal break_tile
signal place_tile

func _ready():
	$BreakTimer.paused = true

func _process(delta):
	sel_tl = World_ptr.get_sel_tl()

func _physics_process(delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_input = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	if x_input == 0:
		$AnimationPlayer.play("idle")
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)
	else:
		if x_input > 0:
			$AnimationPlayer.play("runR")
		else:
			$AnimationPlayer.play("runL")
		velocity.x = move_toward(velocity.x, MAX_SPEED * x_input, ACCELERATION * delta)
	
	if god_mode:
		if y_input == 0:
			velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
		else:
			velocity.y = move_toward(velocity.y, -MAX_SPEED * y_input, ACCELERATION * delta)
	
	if is_on_floor() and !god_mode:
		if Input.is_action_just_pressed("jump"):
			velocity.y = -JUMP_FORCE
	
	if !god_mode:
		velocity.y = move_toward(velocity.y, FALL_SPEED, GRAVITY * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	## block breaking and placing ##
	
	if Input.is_action_pressed("break_tile"):
		if !World_ptr.is_air(sel_tl):
			if $BreakTimer.is_paused():
				$BreakTimer.paused = false
				$BreakTimer.start(get_break_time())
			print("Counting: ", $BreakTimer.time_left)
			if $BreakTimer.is_stopped():
				$BreakTimer.paused = true
				emit_signal("break_tile")
				print("Player: emitted signal 'break_tile'")
	
	if Input.is_action_just_released("break_tile"):
		$BreakTimer.paused = true
	
	if Input.is_action_pressed("place_tile"):
		if World_ptr.is_air(sel_tl):
			emit_signal("place_tile", tl_type_placing)
			print("Player: emitted signal 'place_tile', tile type = ", tl_type_placing)
		else:
			print("Player: failed to place tile")
	
	if Input.is_action_pressed("select_tile"):
		if !World_ptr.is_air(sel_tl):
			tl_type_placing = World_ptr.get_tl_type(sel_tl)
			print("Player: selected tile', tile type = ", tl_type_placing)
		print("Player: failed to select tile", tl_type_placing)
	
	## check for god mode ##
	
	if Input.is_action_just_released("toggle_god_mode"):
		god_mode = !god_mode
		$Body.disabled = god_mode
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
