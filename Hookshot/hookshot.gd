extends Node2D

const SPEED = 50
const MAX_LENGTH = 1000

onready var Hook = $Hook
onready var Rope = $Rope

var direction = Vector2.ZERO
var tip = Vector2.ZERO
var flying = false
var hooked = false

func tip_angle():
	return position.angle_to_point(to_local(tip)) - PI / 2.0;

func shoot(dir):
	direction = dir.normalized()
	flying = true
	tip = global_position
	Hook.rotation = direction.angle() + PI / 2.0

func release():
	flying = false
	hooked = false

func _process(_delta):
	self.visible = flying || hooked
	if !self.visible:
		return
		
	Rope.rotation = tip_angle()
	Rope.position = Hook.position * 0.5
	Rope.region_rect.size.y = Hook.position.length() * 2

func _physics_process(_delta):
	Hook.global_position = tip
	if flying && Hook.move_and_collide(direction * SPEED):
		hooked = true
		flying = false
		
	if Hook.position.length() > MAX_LENGTH:
		release()
		
	tip = Hook.global_position
