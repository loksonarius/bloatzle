extends KinematicBody2D

const MAX_SPEED = 1500
const MIN_SPEED = 10
const MAX_INPUT_SPEED = 300
const ACCELERATION = 2
const YANK_SPEED = 500
const FRICTION = 0.98
const AIM_CURSOR_DIST = 40

onready var Sprite = $Sprite
onready var Body = $Body
onready var Aim = $AimPointer
onready var Hookshot = $Hookshot

var vel = Vector2.ZERO
var taught = false
var hook_yank = Vector2.ZERO
var input_vel = Vector2.ZERO
var aim = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		aim = (mouse_pos - position).normalized()
		Aim.look_at(mouse_pos)
		Aim.position = aim * AIM_CURSOR_DIST
	if event.is_action_pressed("ui_accept") || (event is InputEventMouseButton && event.is_pressed()):
		if Hookshot.hooked:
			var pull = Hookshot.tip - position
			hook_yank = pull.normalized() * YANK_SPEED
			Hookshot.release()
		else:
			Hookshot.shoot(aim)

func update_input():
	var x_dis = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_dis = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vel = Vector2(x_dis, y_dis).normalized()
	if input_vel.length_squared() != 0.0:
		var target = input_vel.angle() - PI / 2.0
		Sprite.rotation = target
		Body.rotation = target

func _process(_delta):
	if aim.length_squared() != 0.0:
		Aim.visible = true

func _physics_process(_delta):
	update_input()
	if input_vel.length_squared() == 0.0:
		apply_friction()
	else:
		var curr_speed = vel.length()
		var accel = input_vel * ACCELERATION
		var sum = vel + accel
		if sum.length() > MAX_INPUT_SPEED:
			print("clamping")
			vel = sum.clamped(curr_speed)
		else:
			vel = sum
		print(vel)
		
	if vel.length_squared() != 0.0 && Hookshot.taught:
		apply_rope_pull()
		
	if hook_yank.length_squared() != 0.0:
		vel += hook_yank
		hook_yank = Vector2.ZERO
		
	vel = vel.clamped(MAX_SPEED)
	vel = move_and_slide(vel)

func apply_friction():
	if vel.length() >= MIN_SPEED:
		vel *= FRICTION
	else:
		vel = Vector2.ZERO

func apply_rope_pull():
	var pull = Hookshot.tip - position
	var angle = vel.angle_to(pull)
	
	if abs(angle) >= PI / 2.0:
		vel -= vel.project(pull)
