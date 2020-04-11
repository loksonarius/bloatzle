extends KinematicBody2D

const MAX_SPEED = 300
const MIN_SPEED = 10
const ACCELERATION = 2
const FRICTION = 0.98

onready var Sprite = $Sprite
onready var Body = $Body

var vel = Vector2.ZERO
var input_vel = Vector2.ZERO

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func update_input():
	var x_dis = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_dis = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vel = Vector2(x_dis, y_dis).normalized()
	if input_vel.length_squared() != 0.0:
		var target = input_vel.angle() - PI / 2.0
		Sprite.rotation = target
		Body.rotation = target

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
