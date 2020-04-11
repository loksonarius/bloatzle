extends KinematicBody2D

const MAX_SPEED = 300
const MIN_SPEED = 10
const ACCELERATION = 2
const FRICTION = 0.98
const AIM_CURSOR_DIST = 40

onready var Sprite = $Sprite
onready var Body = $Body
onready var Aim = $AimPointer

var vel = Vector2.ZERO
var input_vel = Vector2.ZERO
var aim = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		aim = (mouse_pos - position).normalized()
		Aim.look_at(mouse_pos)
		Aim.position = aim * AIM_CURSOR_DIST

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
		apply_acceleration(input_vel * ACCELERATION)
		
	vel = move_and_slide(vel)

func apply_friction():
	if vel.length() >= MIN_SPEED:
		vel *= FRICTION
	else:
		vel = Vector2.ZERO

func apply_acceleration(accel):
	vel += accel
	vel = vel.clamped(MAX_SPEED)
